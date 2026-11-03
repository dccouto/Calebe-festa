<template>
  <section class="admin-card">
    <h2>Confirmações</h2>

    <div class="stats">
      <div class="stat">
        <strong>{{ total }}</strong>
        <span>Pessoas</span>
      </div>
      <div class="stat">
        <strong>{{ contagem.confirmado }}</strong>
        <span>Vão sim</span>
      </div>
      <div class="stat">
        <strong>{{ contagem.talvez }}</strong>
        <span>Talvez</span>
      </div>
      <div class="stat">
        <strong>{{ contagem.nao_pode }}</strong>
        <span>Não podem</span>
      </div>
    </div>

    <p v-if="!itens.length">Nenhuma confirmação ainda.</p>

    <div v-else class="admin-tabela-wrap">
      <table class="admin-tabela">
        <thead>
          <tr>
            <th>Convidado</th>
            <th>Status</th>
            <th>Responsável</th>
            <th>Telefone</th>
            <th>Quando</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in itens" :key="item.id || (item.convidado_nome + item.criado_em)">
            <td>{{ item.convidado_nome || item.nome }}</td>
            <td>
              <span class="pill-status" :class="item.status">{{ rotulo(item.status) }}</span>
            </td>
            <td>{{ item.responsavel_nome || item.responsavel || '—' }}</td>
            <td>{{ item.telefone || '—' }}</td>
            <td>{{ formatarData(item.criado_em) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </section>
</template>

<script>
import { rotuloStatus } from '../servicos/rsvp.js'

export default {
  name: 'AdminConfirmacoes',
  props: {
    itens: {
      type: Array,
      default() {
        return []
      },
    },
  },
  emits: ['recarregar'],
  computed: {
    total() {
      return this.itens.length
    },
    contagem() {
      const base = { confirmado: 0, talvez: 0, nao_pode: 0 }
      for (const item of this.itens) {
        if (base[item.status] !== undefined) base[item.status] += 1
      }
      return base
    },
  },
  methods: {
    rotulo(status) {
      return rotuloStatus(status)
    },
    formatarData(valor) {
      if (!valor) return '—'
      const d = new Date(valor)
      if (Number.isNaN(d.getTime())) return String(valor)
      return d.toLocaleString('pt-BR')
    },
  },
}
</script>
