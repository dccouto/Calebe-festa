<template>
  <header class="hero">
    <div class="hero-visual" aria-hidden="true">
      <VillageArt />
    </div>
    <div class="hero-conteudo">
      <p class="marca">{{ config.marca }}</p>
      <h1 class="titulo">{{ config.nomeAniversariante }} faz {{ config.idade }} anos!</h1>
      <p class="frase">Venha brincar na nossa vila colorida — a festa está completa com você.</p>
      <button type="button" class="cta" @click="$emit('confirmar')">
        Confirmar presença
      </button>
    </div>
  </header>
</template>

<script>
import VillageArt from './VillageArt.vue'

export default {
  name: 'HeroSection',
  components: { VillageArt },
  props: {
    config: {
      type: Object,
      required: true,
    },
  },
  emits: ['confirmar'],
}
</script>

<style scoped>
.hero {
  position: relative;
  min-height: 100svh;
  display: grid;
  align-items: end;
  overflow: hidden;
  color: #2a1a0e;
}

.hero-visual {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.hero-visual :deep(svg) {
  min-height: 100%;
  object-fit: cover;
}

.hero-conteudo {
  position: relative;
  z-index: 1;
  width: min(640px, 100%);
  padding: clamp(1.5rem, 4vw, 3rem);
  padding-bottom: clamp(2rem, 6vw, 4rem);
  background: linear-gradient(
    180deg,
    transparent 0%,
    rgba(255, 248, 230, 0.55) 28%,
    rgba(255, 243, 205, 0.92) 100%
  );
  animation: subir 0.9s ease-out both;
}

.marca {
  margin: 0 0 0.35rem;
  font-family: 'Baloo 2', sans-serif;
  font-weight: 800;
  font-size: clamp(2.4rem, 8vw, 4.2rem);
  line-height: 0.95;
  letter-spacing: -0.02em;
  color: #c45c3e;
  text-shadow: 0 2px 0 rgba(255, 255, 255, 0.45);
}

.titulo {
  margin: 0 0 0.75rem;
  font-family: 'Baloo 2', sans-serif;
  font-weight: 700;
  font-size: clamp(1.45rem, 4.5vw, 2.15rem);
  line-height: 1.15;
  color: #2f5f2a;
}

.frase {
  margin: 0 0 1.35rem;
  max-width: 28rem;
  font-size: clamp(1rem, 2.4vw, 1.15rem);
  line-height: 1.45;
  color: #3d2a1a;
}

.cta {
  appearance: none;
  border: 0;
  cursor: pointer;
  font-family: 'Baloo 2', sans-serif;
  font-weight: 700;
  font-size: 1.15rem;
  padding: 0.85rem 1.6rem;
  border-radius: 14px;
  color: #fff8e7;
  background: linear-gradient(135deg, #e4572e 0%, #c45c3e 55%, #a8462f 100%);
  box-shadow: 0 8px 0 #7a2f1c;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
  animation: cta-pulse 2.4s ease-in-out infinite;
}

.cta:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 0 #7a2f1c;
}

.cta:active {
  transform: translateY(4px);
  box-shadow: 0 4px 0 #7a2f1c;
  animation: none;
}

@keyframes subir {
  from {
    opacity: 0;
    transform: translateY(24px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes cta-pulse {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-3px);
  }
}

@media (min-width: 900px) {
  .hero {
    align-items: center;
    grid-template-columns: 1fr 1.1fr;
  }

  .hero-visual {
    position: relative;
    min-height: 100svh;
  }

  .hero-conteudo {
    order: -1;
    background: linear-gradient(
      120deg,
      rgba(255, 246, 214, 0.96) 0%,
      rgba(255, 246, 214, 0.82) 70%,
      transparent 100%
    );
    min-height: 100svh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding-left: clamp(2rem, 6vw, 5rem);
  }
}

@media (prefers-reduced-motion: reduce) {
  .hero-conteudo,
  .cta {
    animation: none;
  }
}
</style>
