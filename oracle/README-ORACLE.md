# Turma do Calebe — Oracle Cloud (DB + Auth + RSVP)

Arquitetura **espelhada do PipocaGourmet**:

- Front estático no **GitHub Pages** (Vue 3)
- Banco, autenticação e RSVP no **Oracle Autonomous Database + ORDS**
- Proxy Cloudflare para contornar **ORDS-13002** (Origin)

## Schema sugerido

| Recurso | Valor |
|--------|--------|
| Schema REST | `CALEBEF` → `/ords/calebef/` |
| Auth | `POST /ords/calebef/auth/login` · `POST .../auth/senha` · `GET .../auth/ping` |
| RSVP público | `POST /ords/calebef/api/rsvp` (headers `responsavel`, `telefone`, `convidados`) |
| Admin | `GET /ords/calebef/api/confirmacoes` (Bearer) |
| Secrets | `.oci-secrets.env` (gitignored) |

## SQL versionado

| Arquivo | Conteúdo |
|---------|----------|
| `sql/001_schema_calebef.sql` | Usuário + tabelas admin/sessão/RSVP |
| `sql/002_ords_auth.sql` | Pacote auth + módulo ORDS |
| `sql/003_ords_rsvp.sql` | Pacote RSVP + módulo `api` |

Aplicar (com ADB provisionado e ORDS habilitado no schema):

```powershell
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/002_ords_auth.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/apply-sql.ps1 -SqlFile oracle/sql/003_ords_rsvp.sql -SecretsFile .oci-secrets.env
powershell -File oracle/scripts/criar-admin.ps1
```

Chaves esperadas em `.oci-secrets.env` (não versionar):

```
ADB_ORDS_URL=https://XXXX.adb.us-ashburn-1.oraclecloudapps.com/ords
CALEBEF_SCHEMA_PASSWORD=...
ADMIN_APP_EMAIL=voce@email.com
ADMIN_APP_PASSWORD=SenhaForte
```

## Headers do RSVP

O front envia (percent-encoded, como no catálogo do PipocaGourmet):

- `responsavel` — nome de quem confirma
- `telefone` — opcional
- `convidados` — JSON array `[{"nome":"Ana","status":"confirmado"},...]`

Status válidos: `confirmado` | `talvez` | `nao_pode`.
