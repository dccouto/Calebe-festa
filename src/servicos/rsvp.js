import { headersCampos, ORDS_SCHEMA, ordsConfigurado, ordsFetch } from '../lib/ords.js'
import { mensagemErro } from '../lib/erros.js'

const STORAGE_KEY = 'calebe_rsvp_ultimo'

export const STATUS_OPCOES = [
  { valor: 'confirmado', rotulo: 'Vai sim' },
  { valor: 'talvez', rotulo: 'Talvez' },
  { valor: 'nao_pode', rotulo: 'Não pode' },
]

export function rotuloStatus(status) {
  return STATUS_OPCOES.find((o) => o.valor === status)?.rotulo || status
}

export function backendConfigurado() {
  return ordsConfigurado
}

/**
 * Envia confirmação para o Oracle ORDS.
 * @param {{ responsavel: string, telefone?: string, convidados: Array<{ nome: string, status: string }> }} payload
 */
export async function enviarRsvp(payload) {
  const responsavel = String(payload.responsavel || '').trim()
  const telefone = String(payload.telefone || '').trim()
  const convidados = (payload.convidados || [])
    .map((c) => ({
      nome: String(c.nome || '').trim(),
      status: String(c.status || '').trim(),
    }))
    .filter((c) => c.nome)

  if (!responsavel) throw new Error('Informe o nome de quem está confirmando.')
  if (!convidados.length) throw new Error('Adicione pelo menos um convidado.')

  const invalido = convidados.find((c) => !['confirmado', 'talvez', 'nao_pode'].includes(c.status))
  if (invalido) throw new Error('Status de presença inválido.')

  const rascunho = { responsavel, telefone, convidados, enviado_em: new Date().toISOString() }
  localStorage.setItem(STORAGE_KEY, JSON.stringify(rascunho))

  if (!ordsConfigurado) {
    return { ok: true, modo: 'local', ...rascunho }
  }

  try {
    const dados = await ordsFetch(`/${ORDS_SCHEMA}/api/rsvp`, {
      method: 'POST',
      headers: headersCampos({
        responsavel,
        telefone,
        convidados: JSON.stringify(convidados),
      }),
    })
    return { ok: true, modo: 'ords', ...dados, ...rascunho }
  } catch (erro) {
    throw new Error(mensagemErro(erro))
  }
}

/** Lista confirmações (área privada — Bearer). */
export async function listarConfirmacoes() {
  try {
    const dados = await ordsFetch(`/${ORDS_SCHEMA}/api/confirmacoes`, {
      method: 'GET',
      auth: true,
    })
    if (Array.isArray(dados)) return dados
    if (Array.isArray(dados?.items)) return dados.items
    return []
  } catch (erro) {
    throw new Error(mensagemErro(erro))
  }
}

export function lerUltimoRsvpLocal() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function montarMensagemWhatsApp({ responsavel, telefone, convidados }, config) {
  const linhas = convidados.map(
    (c) => `• ${c.nome} — ${rotuloStatus(c.status)}`,
  )
  return [
    `Olá! Confirmação de presença — ${config.marca}`,
    `${config.nomeAniversariante} faz ${config.idade} anos`,
    '',
    `Quem confirmou: ${responsavel}`,
    telefone ? `Telefone: ${telefone}` : null,
    '',
    'Convidados:',
    ...linhas,
  ]
    .filter((l) => l !== null)
    .join('\n')
}

export function urlWhatsApp(numero, texto) {
  const digitos = String(numero || '').replace(/\D/g, '')
  return `https://wa.me/${digitos}?text=${encodeURIComponent(texto)}`
}
