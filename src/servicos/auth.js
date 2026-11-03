import {
  getToken,
  headersCampos,
  ORDS_SCHEMA,
  ordsConfigurado,
  ordsFetch,
  setToken,
} from '../lib/ords.js'
import { mensagemErro } from '../lib/erros.js'

export function backendConfigurado() {
  return ordsConfigurado
}

export async function carregarSessao() {
  const token = getToken()
  if (!token) return null
  return { access_token: token }
}

export async function entrar(email, senha) {
  try {
    const dados = await ordsFetch(`/${ORDS_SCHEMA}/auth/login`, {
      method: 'POST',
      headers: {
        email: email.trim(),
        senha,
      },
    })
    if (!dados?.token) throw new Error(dados?.erro || 'Login sem token')
    setToken(dados.token)
    return { access_token: dados.token, usuario_id: dados.usuario_id }
  } catch (erro) {
    throw new Error(mensagemErro(erro))
  }
}

export async function alterarSenha(senhaAtual, senhaNova) {
  try {
    const dados = await ordsFetch(`/${ORDS_SCHEMA}/auth/senha`, {
      method: 'POST',
      auth: true,
      headers: headersCampos({
        senha_atual: senhaAtual,
        senha_nova: senhaNova,
      }),
    })
    if (!dados?.ok) throw new Error(dados?.erro || 'Falha ao alterar senha')
    return dados
  } catch (erro) {
    throw new Error(mensagemErro(erro))
  }
}

export async function sair() {
  setToken('')
}
