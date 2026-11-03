<template>
  <div class="admin-shell">
    <header class="admin-topo">
      <h1>Painel · Turma do Calebe</h1>
      <div v-if="sessao" class="admin-acoes">
        <button type="button" class="admin-btn fantasma" @click="atualizar">Atualizar lista</button>
        <button type="button" class="admin-btn fantasma" @click="fazerLogout">Sair</button>
      </div>
    </header>

    <p v-if="!ordsOk" class="admin-aviso">
      Oracle ORDS não configurado. Defina <code>VITE_ORDS_BASE_URL</code> no <code>.env</code>
      (local: <code>/ords</code> + <code>ORDS_PROXY_TARGET</code>) — mesmo padrão do PipocaGourmet.
    </p>

    <p v-if="erro" class="admin-erro" role="alert">{{ erro }}</p>
    <p v-if="ok" class="admin-ok" role="status">{{ ok }}</p>

    <AdminLogin
      v-if="ordsOk && !sessao && !carregando"
      :enviando="enviandoLogin"
      @entrar="fazerLogin"
    />

    <p v-if="carregando">Carregando…</p>

    <AdminConfirmacoes
      v-if="sessao && !carregando"
      :itens="confirmacoes"
      @recarregar="atualizar"
    />
  </div>
</template>

<script>
import { backendConfigurado, carregarSessao, entrar, sair } from '../servicos/auth.js'
import { listarConfirmacoes } from '../servicos/rsvp.js'
import { mensagemErro } from '../lib/erros.js'
import AdminLogin from './AdminLogin.vue'
import AdminConfirmacoes from './AdminConfirmacoes.vue'

export default {
  name: 'AdminApp',
  components: {
    AdminLogin,
    AdminConfirmacoes,
  },
  data() {
    return {
      ordsOk: backendConfigurado(),
      sessao: null,
      confirmacoes: [],
      carregando: true,
      enviandoLogin: false,
      erro: '',
      ok: '',
    }
  },
  async mounted() {
    await this.bootstrap()
  },
  methods: {
    async bootstrap() {
      this.carregando = true
      this.erro = ''
      try {
        if (!this.ordsOk) {
          this.sessao = null
          return
        }
        this.sessao = await carregarSessao()
        if (this.sessao) {
          await this.carregarLista()
        }
      } catch (e) {
        this.erro = mensagemErro(e)
        this.sessao = null
      } finally {
        this.carregando = false
      }
    },
    async carregarLista() {
      this.confirmacoes = await listarConfirmacoes()
    },
    async fazerLogin({ email, senha }) {
      this.enviandoLogin = true
      this.erro = ''
      this.ok = ''
      try {
        this.sessao = await entrar(email, senha)
        await this.carregarLista()
        this.ok = 'Bem-vindo(a)!'
      } catch (e) {
        this.erro = mensagemErro(e)
        this.sessao = null
      } finally {
        this.enviandoLogin = false
      }
    },
    async atualizar() {
      this.erro = ''
      this.ok = ''
      try {
        await this.carregarLista()
        this.ok = 'Lista atualizada.'
      } catch (e) {
        this.erro = mensagemErro(e)
      }
    },
    async fazerLogout() {
      await sair()
      this.sessao = null
      this.confirmacoes = []
      this.ok = 'Sessão encerrada.'
    },
  },
}
</script>
