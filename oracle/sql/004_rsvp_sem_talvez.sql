-- Turma do Calebe — migração: remove status "talvez" + DELETE confirmações
-- Schema: CALEBEF (já existente). Aplicar após 003_ords_rsvp.sql.
-- 1) Migra registros antigos "talvez" → "confirmado"
-- 2) Ajusta CHECK constraint
-- 3) Atualiza pacote/handlers ORDS (via 003)

-- Dados antigos: talvez vira confirmado (preserva a pessoa na lista)
UPDATE rsvp_convidado
   SET status = 'confirmado'
 WHERE status = 'talvez';

DECLARE
  l_name VARCHAR2(128);
BEGIN
  SELECT constraint_name INTO l_name
    FROM user_constraints
   WHERE table_name = 'RSVP_CONVIDADO'
     AND constraint_type = 'C'
     AND search_condition_vc LIKE '%confirmado%'
     AND ROWNUM = 1;

  EXECUTE IMMEDIATE 'ALTER TABLE rsvp_convidado DROP CONSTRAINT ' || l_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL; -- constraint inline pode ter outro nome; tenta drop por nomes comuns abaixo
END;
/

BEGIN
  FOR r IN (
    SELECT constraint_name
      FROM user_constraints
     WHERE table_name = 'RSVP_CONVIDADO'
       AND constraint_type = 'C'
       AND (
         search_condition_vc LIKE '%talvez%'
         OR search_condition_vc LIKE '%nao_pode%'
       )
  ) LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE rsvp_convidado DROP CONSTRAINT ' || r.constraint_name;
  END LOOP;
END;
/

ALTER TABLE rsvp_convidado
  ADD CONSTRAINT rsvp_convidado_status_ck
  CHECK (status IN ('confirmado', 'nao_pode'));

COMMIT;
/
