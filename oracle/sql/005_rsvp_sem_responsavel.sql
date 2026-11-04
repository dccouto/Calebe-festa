-- Turma do Calebe — RSVP sem responsável obrigatório
-- Schema: CALEBEF. Aplicar após 003_ords_rsvp.sql (ou reaplicar 003 atualizado).
-- Front deixa de enviar nome/telefone do responsável; coluna permanece para legado.

-- Já é NOT NULL; só define default vazio para inserts sem o campo.
BEGIN
  EXECUTE IMMEDIATE q'[ALTER TABLE rsvp_envio MODIFY (responsavel_nome DEFAULT '')]';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE NOT IN (-1442, -1451) THEN RAISE; END IF;
END;
/

CREATE OR REPLACE PACKAGE rsvp_util AS
  FUNCTION dec(p VARCHAR2) RETURN VARCHAR2;
  FUNCTION registrar_json(
    p_responsavel VARCHAR2,
    p_telefone    VARCHAR2,
    p_convidados  VARCHAR2
  ) RETURN VARCHAR2;
  FUNCTION listar_json(p_auth VARCHAR2) RETURN VARCHAR2;
  FUNCTION excluir_json(p_auth VARCHAR2, p_id NUMBER) RETURN VARCHAR2;
END rsvp_util;
/

CREATE OR REPLACE PACKAGE BODY rsvp_util AS
  FUNCTION dec(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF p IS NULL THEN RETURN NULL; END IF;
    BEGIN
      RETURN UTL_URL.UNESCAPE(p, 'UTF-8');
    EXCEPTION
      WHEN OTHERS THEN RETURN p;
    END;
  END;

  FUNCTION esc_json(p VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN REPLACE(REPLACE(REPLACE(NVL(p, ''), '\', '\\'), '"', '\"'), CHR(10), ' ');
  END;

  FUNCTION registrar_json(
    p_responsavel VARCHAR2,
    p_telefone    VARCHAR2,
    p_convidados  VARCHAR2
  ) RETURN VARCHAR2 IS
    l_resp   VARCHAR2(120) := NVL(TRIM(dec(p_responsavel)), '');
    l_tel    VARCHAR2(40)  := TRIM(NVL(dec(p_telefone), ''));
    l_json   CLOB          := NVL(dec(p_convidados), '[]');
    l_envio  NUMBER;
    l_count  PLS_INTEGER := 0;
    l_arr    JSON_ARRAY_T;
    l_obj    JSON_OBJECT_T;
    l_nome   VARCHAR2(120);
    l_status VARCHAR2(20);
  BEGIN
    BEGIN
      l_arr := JSON_ARRAY_T.parse(l_json);
    EXCEPTION
      WHEN OTHERS THEN
        RETURN '{"erro":"convidados invalido","detalhe":"JSON array esperado"}';
    END;

    IF l_arr.get_size() = 0 THEN
      RETURN '{"erro":"adicione ao menos um convidado"}';
    END IF;

    INSERT INTO rsvp_envio (responsavel_nome, telefone)
    VALUES (l_resp, l_tel)
    RETURNING id INTO l_envio;

    FOR i IN 0 .. l_arr.get_size() - 1 LOOP
      l_obj := TREAT(l_arr.get(i) AS JSON_OBJECT_T);
      l_nome := TRIM(l_obj.get_string('nome'));
      l_status := LOWER(TRIM(l_obj.get_string('status')));
      IF l_nome IS NULL THEN
        CONTINUE;
      END IF;
      IF l_status NOT IN ('confirmado', 'nao_pode') THEN
        ROLLBACK;
        RETURN '{"erro":"status invalido"}';
      END IF;
      INSERT INTO rsvp_convidado (envio_id, convidado_nome, status)
      VALUES (l_envio, l_nome, l_status);
      l_count := l_count + 1;
    END LOOP;

    IF l_count = 0 THEN
      ROLLBACK;
      RETURN '{"erro":"adicione ao menos um convidado"}';
    END IF;

    COMMIT;
    RETURN '{"ok":true,"envio_id":' || TO_CHAR(l_envio) || ',"convidados":' || TO_CHAR(l_count) || '}';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RETURN '{"erro":"falha interna","detalhe":"' || REPLACE(SQLERRM,'"','') || '"}';
  END;

  FUNCTION listar_json(p_auth VARCHAR2) RETURN VARCHAR2 IS
    l_uid  NUMBER;
    l_out  CLOB := '[';
    l_first BOOLEAN := TRUE;
  BEGIN
    l_uid := auth_util.usuario_do_token(p_auth);
    IF l_uid IS NULL THEN
      RETURN '{"erro":"nao autorizado"}';
    END IF;

    FOR r IN (
      SELECT c.id,
             c.envio_id,
             c.convidado_nome,
             c.status,
             e.responsavel_nome,
             e.telefone,
             TO_CHAR(c.criado_em AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS criado_em
        FROM rsvp_convidado c
        JOIN rsvp_envio e ON e.id = c.envio_id
       ORDER BY c.criado_em DESC, c.id DESC
    ) LOOP
      IF NOT l_first THEN
        l_out := l_out || ',';
      END IF;
      l_first := FALSE;
      l_out := l_out
        || '{"id":' || TO_CHAR(r.id)
        || ',"envio_id":' || TO_CHAR(r.envio_id)
        || ',"convidado_nome":"' || esc_json(r.convidado_nome) || '"'
        || ',"status":"' || esc_json(r.status) || '"'
        || ',"responsavel_nome":"' || esc_json(r.responsavel_nome) || '"'
        || ',"telefone":"' || esc_json(r.telefone) || '"'
        || ',"criado_em":"' || esc_json(r.criado_em) || '"}';
    END LOOP;

    l_out := l_out || ']';
    RETURN l_out;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN '{"erro":"falha interna","detalhe":"' || REPLACE(SQLERRM,'"','') || '"}';
  END;

  FUNCTION excluir_json(p_auth VARCHAR2, p_id NUMBER) RETURN VARCHAR2 IS
    l_uid     NUMBER;
    l_envio   NUMBER;
    l_restantes NUMBER;
  BEGIN
    l_uid := auth_util.usuario_do_token(p_auth);
    IF l_uid IS NULL THEN
      RETURN '{"erro":"nao autorizado"}';
    END IF;

    IF p_id IS NULL THEN
      RETURN '{"erro":"id obrigatorio"}';
    END IF;

    BEGIN
      SELECT envio_id INTO l_envio
        FROM rsvp_convidado
       WHERE id = p_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN '{"erro":"confirmacao nao encontrada"}';
    END;

    DELETE FROM rsvp_convidado WHERE id = p_id;

    SELECT COUNT(*) INTO l_restantes
      FROM rsvp_convidado
     WHERE envio_id = l_envio;

    IF l_restantes = 0 THEN
      DELETE FROM rsvp_envio WHERE id = l_envio;
    END IF;

    COMMIT;
    RETURN '{"ok":true,"id":' || TO_CHAR(p_id) || ',"envio_id":' || TO_CHAR(l_envio) || '}';
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RETURN '{"erro":"falha interna","detalhe":"' || REPLACE(SQLERRM,'"','') || '"}';
  END;
END rsvp_util;
/

COMMIT;
