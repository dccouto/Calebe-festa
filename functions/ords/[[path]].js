/**
 * Cloudflare Pages Function — proxy same-origin /ords/*
 * Secret/var: ORDS_PROXY_TARGET = https://XXXX-calebef.adb....oraclecloudapps.com
 * (sem sufixo /ords — o path do request já inclui /ords/...)
 */
import { proxyOrds } from '../../cloudflare/ords-proxy.js'

export async function onRequest(context) {
  return proxyOrds(context.request, context.env, { addCors: true })
}
