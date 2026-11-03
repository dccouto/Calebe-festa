<template>
  <section class="local" id="local">
    <div class="local-inner">
      <h2>Onde e quando</h2>
      <p class="apoio">Anote na agenda!</p>

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
  position: relative;
  padding: clamp(3rem, 8vw, 5rem) clamp(1.25rem, 4vw, 2rem);
  background:
    radial-gradient(circle at 8% 15%, rgba(242, 92, 162, 0.16), transparent 38%),
    radial-gradient(circle at 92% 75%, rgba(255, 214, 10, 0.22), transparent 36%),
    radial-gradient(circle at 50% 100%, rgba(29, 111, 191, 0.12), transparent 40%),
    linear-gradient(180deg, #e8f7ef 0%, #fff4cc 100%);
  border-top: 6px solid #1d6fbf;
}

.local-inner {
  width: min(720px, 100%);
  margin: 0 auto;
}

h2 {
  margin: 0 0 0.4rem;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-size: clamp(1.85rem, 4vw, 2.5rem);
  font-weight: 650;
  color: #1d6fbf;
  text-shadow: 2px 2px 0 rgba(255, 214, 10, 0.55);
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
  border-bottom: 3px dashed rgba(230, 57, 70, 0.28);
}

dt {
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-size: 0.95rem;
  font-weight: 600;
  color: #e63946;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

dd {
  margin: 0;
  font-size: 1.15rem;
  font-weight: 700;
  color: #1f140c;
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
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 650;
  color: #1d6fbf;
  text-decoration: underline;
  text-underline-offset: 3px;
}
</style>
