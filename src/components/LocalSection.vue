<template>
  <section class="local" id="local">
    <div class="local-inner">
      <h2>Onde e quando</h2>
      <p class="apoio">Anote na agenda — o endereço pode ser atualizado depois.</p>

      <dl class="detalhes">
        <div>
          <dt>Data</dt>
          <dd>{{ config.dataTexto }}</dd>
        </div>
        <div>
          <dt>Horário</dt>
          <dd>{{ config.horario }}</dd>
        </div>
        <div>
          <dt>Local</dt>
          <dd>{{ config.localNome }}</dd>
        </div>
        <div>
          <dt>Endereço</dt>
          <dd>
            {{ config.endereco }}
            <span v-if="config.complemento" class="comp">{{ config.complemento }}</span>
          </dd>
        </div>
      </dl>

      <a
        v-if="config.mapsUrl"
        class="maps"
        :href="config.mapsUrl"
        target="_blank"
        rel="noopener noreferrer"
      >
        Abrir no mapa
      </a>
    </div>
  </section>
</template>

<script>
export default {
  name: 'LocalSection',
  props: {
    config: {
      type: Object,
      required: true,
    },
  },
}
</script>

<style scoped>
.local {
  padding: clamp(3rem, 8vw, 5rem) clamp(1.25rem, 4vw, 2rem);
  background:
    radial-gradient(circle at 10% 20%, rgba(75, 163, 217, 0.18), transparent 40%),
    radial-gradient(circle at 90% 80%, rgba(245, 197, 24, 0.22), transparent 35%),
    linear-gradient(180deg, #eef8ef 0%, #f7f1df 100%);
}

.local-inner {
  width: min(720px, 100%);
  margin: 0 auto;
}

h2 {
  margin: 0 0 0.4rem;
  font-family: 'Baloo 2', sans-serif;
  font-size: clamp(1.8rem, 4vw, 2.4rem);
  color: #2f5f2a;
}

.apoio {
  margin: 0 0 1.75rem;
  color: #5a4332;
  max-width: 34rem;
}

.detalhes {
  margin: 0;
  display: grid;
  gap: 1.1rem;
}

.detalhes div {
  display: grid;
  gap: 0.2rem;
  padding-bottom: 1rem;
  border-bottom: 2px dashed rgba(139, 90, 43, 0.25);
}

dt {
  font-family: 'Baloo 2', sans-serif;
  font-size: 0.95rem;
  color: #c45c3e;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

dd {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 700;
  color: #2a1a0e;
}

.comp {
  display: block;
  margin-top: 0.25rem;
  font-weight: 600;
  color: #5a4332;
  font-size: 1rem;
}

.maps {
  display: inline-block;
  margin-top: 1.5rem;
  font-weight: 800;
  color: #2e6f9a;
  text-decoration: underline;
  text-underline-offset: 3px;
}
</style>
