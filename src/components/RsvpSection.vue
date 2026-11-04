<template>
  <section class="rsvp" id="rsvp">
    <div class="rsvp-inner">
      <h2>Confirmar presença</h2>
      <p class="apoio">
        Informe quem vem e se realmente poderão ir.
      </p>

      <form class="formulario" @submit.prevent="enviar">
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
      return this.convidados.some((c) => c.nome)
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
    radial-gradient(circle at 90% 10%, rgba(242, 92, 162, 0.18), transparent 35%),
    linear-gradient(165deg, #fff1b8 0%, #ffe08a 38%, #c8ebff 100%);
  border-top: 6px solid #ffd60a;
}

.rsvp-inner {
  width: min(720px, 100%);
  margin: 0 auto;
}

h2 {
  margin: 0 0 0.4rem;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-size: clamp(1.85rem, 4vw, 2.5rem);
  font-weight: 650;
  color: #e63946;
  text-shadow: 2px 2px 0 rgba(255, 255, 255, 0.55);
}

.apoio {
  margin: 0 0 1.75rem;
  color: #5a4332;
}

.formulario {
  background: rgba(255, 248, 232, 0.88);
  border: 4px solid #1f140c;
  border-radius: 20px;
  padding: clamp(1.1rem, 3vw, 1.6rem);
  box-shadow: 0 10px 0 rgba(29, 111, 191, 0.22);
}

.campo {
  display: grid;
  gap: 0.35rem;
  margin-bottom: 1rem;
}

.campo span {
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-size: 0.95rem;
  font-weight: 550;
  color: #2a7a2e;
}

.campo input,
.campo select {
  font: inherit;
  padding: 0.75rem 0.9rem;
  border-radius: 12px;
  border: 2.5px solid rgba(29, 111, 191, 0.4);
  background: #fffdf7;
  color: #1f140c;
}

.campo input:focus,
.campo select:focus {
  outline: 3px solid rgba(242, 92, 162, 0.4);
  border-color: #f25ca2;
}

.lista-convidados {
  margin: 0 0 0.5rem;
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
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-size: 1.25rem;
  font-weight: 600;
  color: #1d6fbf;
}

.convidado {
  display: grid;
  gap: 0.65rem;
  padding: 0.85rem;
  border-radius: 14px;
  background: rgba(29, 111, 191, 0.08);
  border: 2.5px dashed rgba(29, 111, 191, 0.35);
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
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 650;
  border-radius: 12px;
  cursor: pointer;
}

.btn-primario {
  border: 3px solid #1f140c;
  padding: 0.85rem 1.35rem;
  color: #fff8e8;
  background: linear-gradient(135deg, #3d9e3a, #2a7a2e);
  box-shadow: 0 5px 0 #1a5a2a;
}

.btn-primario:disabled {
  opacity: 0.65;
  cursor: wait;
}

.btn-secundario {
  border: 2.5px solid #1d6fbf;
  background: #eaf6ff;
  color: #1d6fbf;
  padding: 0.45rem 0.9rem;
}

.btn-whatsapp {
  border: 2.5px solid #1f7a45;
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
  color: #e63946;
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
