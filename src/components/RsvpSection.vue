<template>
  <section class="rsvp" id="rsvp">
    <div class="rsvp-inner">
      <h2>Confirmar presença</h2>
      <p class="apoio">
        Informe quem vem e se realmente poderão ir. A confirmação é salva no banco da festa
        <template v-if="ordsOk"> (Oracle)</template>
        <template v-else> (modo local até configurar a API)</template>.
      </p>

      <form class="formulario" @submit.prevent="enviar">
        <label class="campo">
          <span>Seu nome</span>
          <input v-model.trim="responsavel" type="text" name="responsavel" autocomplete="name" required placeholder="Quem está respondendo" />
        </label>

        <label class="campo">
          <span>Telefone / WhatsApp (opcional)</span>
          <input v-model.trim="telefone" type="tel" name="telefone" autocomplete="tel" placeholder="(11) 99999-9999" />
        </label>

        <div class="lista-convidados">
          <div class="lista-cabecalho">
            <h3>Quem vai?</h3>
            <button type="button" class="btn-secundario" @click="adicionar">Adicionar pessoa</button>
          </div>

          <div v-for="(pessoa, indice) in convidados" :key="pessoa.id" class="convidado">
            <label class="campo nome">
              <span>Nome</span>
              <input v-model.trim="pessoa.nome" type="text" required placeholder="Nome do convidado" />
            </label>
            <label class="campo status">
              <span>Presença</span>
              <select v-model="pessoa.status" required>
                <option v-for="op in statusOpcoes" :key="op.valor" :value="op.valor">
                  {{ op.rotulo }}
                </option>
              </select>
            </label>
            <button
              v-if="convidados.length > 1"
              type="button"
              class="remover"
              :aria-label="'Remover ' + (pessoa.nome || 'pessoa')"
              @click="remover(indice)"
            >
              Remover
            </button>
          </div>
        </div>

        <p v-if="erro" class="msg erro" role="alert">{{ erro }}</p>
        <p v-if="sucesso" class="msg ok" role="status">{{ sucesso }}</p>

        <div class="acoes">
          <button type="submit" class="btn-primario" :disabled="enviando">
            {{ enviando ? 'Enviando…' : 'Enviar confirmação' }}
          </button>
          <button type="button" class="btn-whatsapp" :disabled="!podeWhatsApp" @click="abrirWhatsApp">
            Também avisar no WhatsApp
          </button>
        </div>
      </form>
    </div>
  </section>
</template>

<script>
import {
  STATUS_OPCOES,
  backendConfigurado,
  enviarRsvp,
  montarMensagemWhatsApp,
  urlWhatsApp,
} from '../servicos/rsvp.js'

let seq = 1

function pessoaVazia() {
  return { id: seq++, nome: '', status: 'confirmado' }
}

export default {
  name: 'RsvpSection',
  props: {
    config: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      responsavel: '',
      telefone: '',
      convidados: [pessoaVazia()],
      statusOpcoes: STATUS_OPCOES,
      enviando: false,
      erro: '',
      sucesso: '',
      ordsOk: backendConfigurado(),
    }
  },
  computed: {
    podeWhatsApp() {
      return Boolean(this.responsavel && this.convidados.some((c) => c.nome))
    },
  },
  methods: {
    adicionar() {
      this.convidados.push(pessoaVazia())
    },
    remover(indice) {
      this.convidados.splice(indice, 1)
    },
    payload() {
      return {
        responsavel: this.responsavel,
        telefone: this.telefone,
        convidados: this.convidados.map((c) => ({
          nome: c.nome,
          status: c.status,
        })),
      }
    },
    async enviar() {
      this.erro = ''
      this.sucesso = ''
      this.enviando = true
      try {
        const resultado = await enviarRsvp(this.payload())
        if (resultado.modo === 'ords') {
          this.sucesso = 'Presença registrada! Obrigado — nos vemos na festa.'
        } else {
          this.sucesso =
            'Salvo neste aparelho. Configure a API Oracle (VITE_ORDS_BASE_URL) para gravar no banco, ou use o WhatsApp abaixo.'
        }
      } catch (e) {
        this.erro = e.message || 'Não foi possível enviar.'
      } finally {
        this.enviando = false
      }
    },
    abrirWhatsApp() {
      const texto = montarMensagemWhatsApp(this.payload(), this.config)
      window.open(urlWhatsApp(this.config.whatsapp, texto), '_blank', 'noopener,noreferrer')
    },
  },
}
</script>

<style scoped>
.rsvp {
  padding: clamp(3rem, 8vw, 5.5rem) clamp(1.25rem, 4vw, 2rem);
  background:
    linear-gradient(160deg, #fff6d8 0%, #ffe8b8 40%, #d9f0ff 100%);
}

.rsvp-inner {
  width: min(720px, 100%);
  margin: 0 auto;
}

h2 {
  margin: 0 0 0.4rem;
  font-family: 'Baloo 2', sans-serif;
  font-size: clamp(1.8rem, 4vw, 2.4rem);
  color: #c45c3e;
}

.apoio {
  margin: 0 0 1.75rem;
  color: #5a4332;
}

.formulario {
  background: rgba(255, 255, 255, 0.72);
  border: 3px solid rgba(139, 90, 43, 0.2);
  border-radius: 18px;
  padding: clamp(1.1rem, 3vw, 1.6rem);
  box-shadow: 0 12px 0 rgba(139, 90, 43, 0.08);
}

.campo {
  display: grid;
  gap: 0.35rem;
  margin-bottom: 1rem;
}

.campo span {
  font-family: 'Baloo 2', sans-serif;
  font-size: 0.95rem;
  color: #2f5f2a;
}

.campo input,
.campo select {
  font: inherit;
  padding: 0.75rem 0.9rem;
  border-radius: 12px;
  border: 2px solid rgba(46, 111, 154, 0.35);
  background: #fffdf7;
  color: #2a1a0e;
}

.campo input:focus,
.campo select:focus {
  outline: 3px solid rgba(75, 163, 217, 0.45);
  border-color: #4ba3d9;
}

.lista-convidados {
  margin: 1.25rem 0 0.5rem;
  display: grid;
  gap: 0.85rem;
}

.lista-cabecalho {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
}

.lista-cabecalho h3 {
  margin: 0;
  font-family: 'Baloo 2', sans-serif;
  font-size: 1.25rem;
  color: #2e6f9a;
}

.convidado {
  display: grid;
  gap: 0.65rem;
  padding: 0.85rem;
  border-radius: 14px;
  background: rgba(75, 163, 217, 0.08);
  border: 2px dashed rgba(46, 111, 154, 0.25);
}

@media (min-width: 640px) {
  .convidado {
    grid-template-columns: 1.4fr 1fr auto;
    align-items: end;
  }

  .convidado .campo {
    margin-bottom: 0;
  }
}

.acoes {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1.25rem;
}

.btn-primario,
.btn-secundario,
.btn-whatsapp,
.remover {
  font: inherit;
  font-family: 'Baloo 2', sans-serif;
  font-weight: 700;
  border-radius: 12px;
  cursor: pointer;
}

.btn-primario {
  border: 0;
  padding: 0.85rem 1.35rem;
  color: #fff8e7;
  background: linear-gradient(135deg, #2f8f46, #247a3a);
  box-shadow: 0 5px 0 #1a5a2a;
}

.btn-primario:disabled {
  opacity: 0.65;
  cursor: wait;
}

.btn-secundario {
  border: 2px solid #2e6f9a;
  background: #eaf6ff;
  color: #2e6f9a;
  padding: 0.45rem 0.9rem;
}

.btn-whatsapp {
  border: 2px solid #1f7a45;
  background: #e8fff0;
  color: #1f7a45;
  padding: 0.75rem 1.1rem;
}

.btn-whatsapp:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.remover {
  border: 0;
  background: transparent;
  color: #a8462f;
  padding: 0.4rem 0.2rem;
  text-decoration: underline;
  text-underline-offset: 3px;
}

.msg {
  margin: 0.75rem 0 0;
  font-weight: 700;
}

.msg.erro {
  color: #a12020;
}

.msg.ok {
  color: #1f7a45;
}
</style>
