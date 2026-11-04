# Turma do Calebe — Oracle Cloud (DB + Auth + RSVP)

Arquitetura **espelhada do PipocaGourmet**:

- Front estático no **GitHub Pages** (Vue 3)
- Banco, autenticação e RSVP no **Oracle Autonomous Database + ORDS**
- Proxy Cloudflare para contornar **ORDS-13002** (Origin)

## Provisionado

| Recurso | Valor |
|--------|--------|
| ADB (compartilhado com PipocaGourmet) | Display `PipocaGourmet`, DB name `PIPOCAG`, região `us-ashburn-1` |
| Schema REST | `CALEBEF` → `/ords/calebef/` |
| Auth | `GET .../auth/ping` · `POST .../auth/login` · `POST .../auth/senha` |
| RSVP público | `POST /ords/calebef/api/rsvp` (header `convidados`; `responsavel`/`telefone` opcionais/legado) |
| Admin | `GET /ords/calebef/api/confirmacoes` · `DELETE /ords/calebef/api/confirmacoes/:id` (Bearer) |
| Worker proxy | `https://calebe-ords-proxy.dccouto.workers.dev/ords` |
| Secrets | `.oci-secrets.env` (+ cópia `~\.oci\calebe-festa.env`) — gitignored |

O schema `CALEBEF` vive **no mesmo ADB** do Pipoca (`PIPOCAG`); só o usuário/ORDS path é novo.

## SQL versionado

| Arquivo | Conteúdo |
|---------|----------|
| `sql/001_schema_calebef.sql` | Usuário + tabelas admin/sessão/RSVP |
| `sql/002_ords_auth.sql` | Pacote auth + módulo ORDS |
| `sql/003_ords_rsvp.sql` | Pacote RSVP + módulo `api` (POST/GET/DELETE) |
| `sql/004_rsvp_sem_talvez.sql` | Migração: remove status `talvez` + CHECK |
| `sql/005_rsvp_sem_responsavel.sql` | Migração: `responsavel_nome`/`telefone` nullable (evita ORA-01400; `''`=NULL no Oracle) |

Aplicar (com ADB provisionado e ORDS habilitado no schema):

```powershell
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/002_ords_auth.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/004_rsvp_sem_talvez.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/003_ords_rsvp.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/005_rsvp_sem_responsavel.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/criar-admin.ps1
```

Chaves esperadas em `.oci-secrets.env` (não versionar):

```
ADB_ORDS_URL=https://G9FABC6EE6070CE-PIPOCAG.adb.us-ashburn-1.oraclecloudapps.com/ords/
CALEBEF_SCHEMA_PASSWORD=...
ADMIN_APP_EMAIL=admin@calebe-festa.local
ADMIN_APP_PASSWORD=...
```

Admin de app: e-mail em `ADMIN_APP_EMAIL`; senha só em `.oci-secrets.env` / `~\.oci\calebe-festa.env`.

## Headers do RSVP

O front envia (percent-encoded, como no catálogo do PipocaGourmet):

- `convidados` — JSON array `[{"nome":"Ana","status":"confirmado"},...]` (obrigatório)
- `responsavel` / `telefone` — opcionais/legado (o site omite; colunas nullable no ADB)

Status válidos: `confirmado` | `nao_pode`.
