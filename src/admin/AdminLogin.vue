<template>
  <section class="admin-card">
    <h2>Entrar</h2>
    <p>Área privada da família — use o e-mail e a senha do admin (Oracle).</p>
    <form @submit.prevent="enviar">
      <label class="admin-campo">
        <span>E-mail</span>
        <input v-model.trim="email" type="email" required autocomplete="username" />
      </label>
      <label class="admin-campo">
        <span>Senha</span>
        <input v-model="senha" type="password" required autocomplete="current-password" />
      </label>
      <div class="admin-acoes">
        <button type="submit" class="admin-btn primario" :disabled="enviando">
          {{ enviando ? 'Entrando…' : 'Entrar' }}
        </button>
      </div>
    </form>
  </section>
</template>

<script>
export default {
  name: 'AdminLogin',
  props: {
    enviando: {
      type: Boolean,
      default: false,
    },
  },
  emits: ['entrar'],
  data() {
    return {
      email: '',
      senha: '',
    }
  },
  methods: {
    enviar() {
      this.$emit('entrar', { email: this.email, senha: this.senha })
    },
  },
}
</script>
