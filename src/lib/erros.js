export function mensagemErro(erro) {
  if (!erro) return 'Algo deu errado.'
  const texto = typeof erro === 'string' ? erro : erro.message || String(erro)

  if (/Failed to fetch|NetworkError|fetch/i.test(texto)) {
    return 'Sem conexão com o Oracle ORDS. Confira VITE_ORDS_BASE_URL e a rede.'
  }
  if (/credenciais invalidas|nao autorizado|não autorizado/i.test(texto)) {
    return 'E-mail ou senha incorretos, ou sessão expirada.'
  }
  if (/ORDS não configurado|não configurado/i.test(texto)) {
    return texto
  }
  return texto
}
