-- Turma do Calebe — ORDS auth (espelho PipocaGourmet)
-- Schema: CALEBEF | Base path: /ords/calebef/
--   GET  /ords/calebef/auth/ping
--   POST /ords/calebef/auth/login   (headers: email, senha)
--   POST /ords/calebef/auth/senha   (Bearer + headers senha_atual, senha_nova)

CREATE OR REPLACE PACKAGE auth_util AS
  FUNCTION sha256_hex(p_text VARCHAR2) RETURN VARCHAR2;
  FUNCTION login_json(p_email VARCHAR2, p_senha VARCHAR2) RETURN VARCHAR2;
  FUNCTION alterar_senha_json(
    p_auth        VARCHAR2,
    p_senha_atual VARCHAR2,
    p_senha_nova  VARCHAR2
  ) RETURN VARCHAR2;
  FUNCTION usuario_do_token(p_auth VARCHAR2) RETURN NUMBER;
END auth_util;
/

CREATE OR REPLACE PACKAGE BODY auth_util AS
  FUNCTION sha256_hex(p_text VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN LOWER(RAWTOHEX(DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(p_text), DBMS_CRYPTO.HASH_SH256)));
  END;

  FUNCTION dec(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    BEGIN
      RETURN UTL_URL.UNESCAPE(p, 'UTF-8');
    EXCEPTION
      WHEN OTHERS THEN RETURN p;
    END;
  END;

  FUNCTION usuario_do_token(p_auth VARCHAR2) RETURN NUMBER IS
    l_raw   VARCHAR2(4000) := TRIM(NVL(p_auth, ''));
    l_token VARCHAR2(256);
    l_hash  VARCHAR2(128);
    l_uid   NUMBER;
  BEGIN
    IF UPPER(SUBSTR(l_raw, 1, 7)) = 'BEARER ' THEN
      l_token := TRIM(SUBSTR(l_raw, 8));
    ELSE
      l_token := l_raw;
    END IF;
    IF l_token IS NULL THEN RETURN NULL; END IF;

    l_hash := sha256_hex(l_token);

    SELECT s.usuario_id INTO l_uid
      FROM sessao_token s
      JOIN usuarios_admin u ON u.id = s.usuario_id
     WHERE s.token_hash = l_hash
       AND s.expira_em > SYSTIMESTAMP
       AND u.ativo = 1
       AND ROWNUM = 1;

    RETURN l_uid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
    WHEN OTHERS THEN RETURN NULL;
  END;

  FUNCTION confere_senha(p_hash VARCHAR2, p_senha VARCHAR2) RETURN BOOLEAN IS
    l_algo   VARCHAR2(32);
    l_salt   VARCHAR2(64);
    l_expect VARCHAR2(128);
    l_calc   VARCHAR2(128);
    l_pos1   PLS_INTEGER;
    l_pos2   PLS_INTEGER;
  BEGIN
    IF p_hash IS NULL OR p_senha IS NULL THEN RETURN FALSE; END IF;
    l_pos1 := INSTR(p_hash, CHR(36));
    l_pos2 := INSTR(p_hash, CHR(36), l_pos1 + 1);
    IF l_pos1 = 0 OR l_pos2 = 0 THEN RETURN FALSE; END IF;
    l_algo   := SUBSTR(p_hash, 1, l_pos1 - 1);
    l_salt   := SUBSTR(p_hash, l_pos1 + 1, l_pos2 - l_pos1 - 1);
    l_expect := SUBSTR(p_hash, l_pos2 + 1);
    IF l_algo <> 'sha256' THEN RETURN FALSE; END IF;
    l_calc := sha256_hex(l_salt || p_senha);
    RETURN l_calc = LOWER(l_expect);
  END;

  FUNCTION login_json(p_email VARCHAR2, p_senha VARCHAR2) RETURN VARCHAR2 IS
    l_email  VARCHAR2(320) := LOWER(TRIM(p_email));
    l_senha  VARCHAR2(255) := p_senha;
    l_id     NUMBER;
    l_hash   VARCHAR2(255);
    l_token  VARCHAR2(64);
    l_thash  VARCHAR2(128);
  BEGIN
    IF l_email IS NULL OR l_senha IS NULL THEN
      RETURN '{"erro":"email e senha obrigatorios"}';
    END IF;

    BEGIN
      SELECT id, senha_hash INTO l_id, l_hash
        FROM usuarios_admin
       WHERE LOWER(email) = l_email AND ativo = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN '{"erro":"credenciais invalidas"}';
    END;

    IF NOT confere_senha(l_hash, l_senha) THEN
      RETURN '{"erro":"credenciais invalidas"}';
    END IF;

    l_token := LOWER(RAWTOHEX(SYS_GUID())) || LOWER(RAWTOHEX(SYS_GUID()));
    l_thash := sha256_hex(l_token);
    INSERT INTO sessao_token (usuario_id, token_hash, expira_em)
    VALUES (l_id, l_thash, SYSTIMESTAMP + NUMTODSINTERVAL(12, 'HOUR'));
    COMMIT;

    RETURN '{"token":"' || l_token || '","expira_horas":12,"usuario_id":' || TO_CHAR(l_id) || '}';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '{"erro":"falha interna","detalhe":"' || REPLACE(SQLERRM,'"','') || '"}';
  END;

  FUNCTION alterar_senha_json(
    p_auth        VARCHAR2,
    p_senha_atual VARCHAR2,
    p_senha_nova  VARCHAR2
  ) RETURN VARCHAR2 IS
    l_uid   NUMBER;
    l_hash  VARCHAR2(255);
    l_atual VARCHAR2(255) := dec(p_senha_atual);
    l_nova  VARCHAR2(255) := dec(p_senha_nova);
    l_salt  VARCHAR2(64);
  BEGIN
    l_uid := usuario_do_token(p_auth);
    IF l_uid IS NULL THEN
      RETURN '{"erro":"nao autorizado"}';
    END IF;
    IF l_atual IS NULL OR l_nova IS NULL OR LENGTH(l_nova) < 6 THEN
      RETURN '{"erro":"senha invalida"}';
    END IF;

    SELECT senha_hash INTO l_hash FROM usuarios_admin WHERE id = l_uid;
    IF NOT confere_senha(l_hash, l_atual) THEN
      RETURN '{"erro":"senha atual incorreta"}';
    END IF;

    l_salt := LOWER(RAWTOHEX(SYS_GUID()));
    UPDATE usuarios_admin
       SET senha_hash = 'sha256$' || l_salt || '$' || sha256_hex(l_salt || l_nova),
           atualizado_em = SYSTIMESTAMP
     WHERE id = l_uid;
    COMMIT;
    RETURN '{"ok":true}';
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '{"erro":"falha interna","detalhe":"' || REPLACE(SQLERRM,'"','') || '"}';
  END;
END auth_util;
/

BEGIN
  ORDS.DEFINE_MODULE(
    p_module_name    => 'auth',
    p_base_path      => 'auth/',
    p_items_per_page => 0,
    p_status         => 'PUBLISHED',
    p_comments       => 'Login admin Turma do Calebe'
  );

  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'auth', p_pattern => 'login',
    p_priority => 0, p_etag_type => 'HASH', p_comments => 'POST login'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'auth', p_pattern => 'login', p_method => 'POST',
    p_source_type => 'plsql/block',
    p_source => q'[BEGIN htp.p(auth_util.login_json(:email, :senha)); END;]'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name => 'auth', p_pattern => 'login', p_method => 'POST',
    p_name => 'email', p_bind_variable_name => 'email',
    p_source_type => 'HEADER', p_param_type => 'STRING', p_access_method => 'IN'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name => 'auth', p_pattern => 'login', p_method => 'POST',
    p_name => 'senha', p_bind_variable_name => 'senha',
    p_source_type => 'HEADER', p_param_type => 'STRING', p_access_method => 'IN'
  );

  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'auth', p_pattern => 'ping',
    p_priority => 0, p_etag_type => 'HASH', p_comments => 'health'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'auth', p_pattern => 'ping', p_method => 'GET',
    p_source_type => 'plsql/block',
    p_source => 'BEGIN htp.p(''{"ok":true}''); END;'
  );

  ORDS.DEFINE_TEMPLATE(
    p_module_name => 'auth', p_pattern => 'senha',
    p_priority => 0, p_etag_type => 'HASH', p_comments => 'POST alterar senha'
  );

  ORDS.DEFINE_HANDLER(
    p_module_name => 'auth', p_pattern => 'senha', p_method => 'POST',
    p_source_type => 'plsql/block',
    p_source => q'[BEGIN htp.p(auth_util.alterar_senha_json(:authorization, :senha_atual, :senha_nova)); END;]'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name => 'auth', p_pattern => 'senha', p_method => 'POST',
    p_name => 'Authorization', p_bind_variable_name => 'authorization',
    p_source_type => 'HEADER', p_param_type => 'STRING', p_access_method => 'IN'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name => 'auth', p_pattern => 'senha', p_method => 'POST',
    p_name => 'senha_atual', p_bind_variable_name => 'senha_atual',
    p_source_type => 'HEADER', p_param_type => 'STRING', p_access_method => 'IN'
  );

  ORDS.DEFINE_PARAMETER(
    p_module_name => 'auth', p_pattern => 'senha', p_method => 'POST',
    p_name => 'senha_nova', p_bind_variable_name => 'senha_nova',
    p_source_type => 'HEADER', p_param_type => 'STRING', p_access_method => 'IN'
  );

  ORDS.SET_MODULE_ORIGINS_ALLOWED(p_module_name => 'auth', p_origins_allowed => '*');
  COMMIT;
END;
/
