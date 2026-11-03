# Turma do Calebe — festa de 2 anos

Convite digital + confirmação de presença (RSVP), com painel privado para a família.

**Front:** Vue 3 (Options API / estilo Vue 2) + Vite MPA (`/` e `/admin/`) → **GitHub Pages**  
**Backend:** Oracle Autonomous Database + ORDS na **OCI** (mesmo padrão do [PipocaGourmet](../PipocaGourmet))  
**Proxy prod:** Cloudflare Worker/Pages (contorna `ORDS-13002`)

## O que tem no site

- Hero **Turma do Calebe** + aniversário de 2 anos (tema visual da vila, ilustração SVG própria)
- Seção de local/data/hora (placeholders em `src/config.js`)
- RSVP multi-pessoa (nome + status: vai / talvez / não pode) → grava no Oracle
- Extra opcional: aviso via WhatsApp
- Área privada `/admin/` com login e lista de confirmações

## Rodar local

```powershell
npm install
copy .env.example .env
# .env (sem BOM UTF-8):
#   VITE_ORDS_BASE_URL=/ords
#   ORDS_PROXY_TARGET=https://g9fabc6ee6070ce-pipocag.adb.us-ashburn-1.oraclecloudapps.com
npm run dev
```

- Convite: http://localhost:5173/
- Admin: http://localhost:5173/admin/

Sem `.env` / ORDS, o formulário ainda funciona em modo local (localStorage) + WhatsApp.

## Onde editar

| O quê | Onde |
|-------|------|
| Endereço, data, horário, WhatsApp | `src/config.js` |
| URL da API ORDS | `.env` → `VITE_ORDS_BASE_URL` (+ `ORDS_PROXY_TARGET` no local) |
| Credenciais admin / senhas OCI | `.oci-secrets.env` (**nunca commitado**) |

## Como funciona o RSVP

1. Convidado preenche responsável, telefone (opcional) e uma ou mais pessoas com status.
2. O front chama `POST /ords/calebef/api/rsvp` (headers percent-encoded, igual PipocaGourmet).
3. Oracle grava em `rsvp_envio` + `rsvp_convidado`.
4. Também guarda uma cópia local do último envio e pode abrir WhatsApp com a lista.
5. No `/admin/`, após login (`POST /ords/calebef/auth/login`), `GET /ords/calebef/api/confirmacoes` lista tudo.

## Deploy GitHub Pages

Workflow: `.github/workflows/pages.yml`  
Secret Actions: `VITE_ORDS_BASE_URL` = `https://calebe-ords-proxy.dccouto.workers.dev/ords` (**Worker**, não a URL crua do ADB).

```bash
npm run build   # saída em dist/
```

`VITE_BASE` no CI = `/NomeDoRepo/` para Pages em project site.  
Produção esperada: `https://dccouto.github.io/Calebe-festa/` (+ `/admin/`).

## Oracle (OCI)

Detalhes: [`oracle/README-ORACLE.md`](oracle/README-ORACLE.md)  
Proxy: [`cloudflare/README.md`](cloudflare/README.md)

Schema `CALEBEF` no ADB compartilhado com PipocaGourmet; SQL `001`–`003` aplicados; admin em `.oci-secrets.env`; Worker `calebe-ords-proxy` publicado.

## Stack (Vue)

- Vue 3 com **Options API** (`data`, `methods`, `computed`, `mounted`) — padrão familiar ao Vue 2
- Sem Composition API / `<script setup>` / Pinia
- Componentes `.vue` em `src/components` e `src/admin`
