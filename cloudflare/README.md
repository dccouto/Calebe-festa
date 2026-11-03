# Proxy ORDS (Cloudflare) — Turma do Calebe

Mesmo padrão do **PipocaGourmet**: o Oracle ADB ORDS rejeita requests com header `Origin` (**ORDS-13002**). O browser no GitHub Pages **não** pode chamar a URL do ADB diretamente.

Este proxy:

1. Encaminha `/ords/*` para `ORDS_PROXY_TARGET`
2. **Remove** `Origin` e `Referer` antes de falar com o ADB
3. Responde `OPTIONS` com CORS (modo Worker)

## Opção A — Worker + GitHub Pages

```bash
npx wrangler login
npx wrangler secret put ORDS_PROXY_TARGET
# valor: https://g9fabc6ee6070ce-pipocag.adb.us-ashburn-1.oraclecloudapps.com
# (sem /ords no final — mesmo ADB do PipocaGourmet)

npx wrangler secret put CORS_ALLOW_ORIGINS
# valor: https://dccouto.github.io,http://localhost:5173

npx wrangler deploy
```

Worker em produção: `https://calebe-ords-proxy.dccouto.workers.dev`

No GitHub → Settings → Secrets → Actions:

| Secret | Valor |
|--------|--------|
| `VITE_ORDS_BASE_URL` | `https://calebe-ords-proxy.dccouto.workers.dev/ords` |

## Opção B — Cloudflare Pages (same-origin)

`VITE_ORDS_BASE_URL=/ords` + Function `functions/ords/[[path]].js` + var `ORDS_PROXY_TARGET`.

## Local

```
VITE_ORDS_BASE_URL=/ords
ORDS_PROXY_TARGET=https://XXXX-calebef.adb....oraclecloudapps.com
npm run dev
```
