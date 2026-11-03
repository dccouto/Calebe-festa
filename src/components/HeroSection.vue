<template>
  <header class="hero">
    <div class="hero-visual" aria-hidden="true">
      <VillageArt />
      <div class="hero-vinheta" />
    </div>
    <div class="hero-conteudo">
      <p class="marca">{{ config.marca }}</p>
      <h1 class="titulo">{{ config.nomeAniversariante }} faz {{ config.idade }} anos!</h1>
      <p class="frase">Venha brincar na nossa vila colorida — a festa fica completa com você.</p>
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
  display: flex;
  align-items: flex-end;
  overflow: hidden;
  color: #1f140c;
}

.hero-visual {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.hero-visual :deep(svg) {
  width: 100%;
  height: 100%;
  min-height: 100%;
  object-fit: cover;
}

.hero-vinheta {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background:
    linear-gradient(
      180deg,
      transparent 0%,
      transparent 42%,
      rgba(31, 20, 12, 0.18) 68%,
      rgba(31, 20, 12, 0.45) 100%
    ),
    radial-gradient(ellipse at 50% 120%, rgba(255, 214, 10, 0.28), transparent 55%);
}

.hero-conteudo {
  position: relative;
  z-index: 1;
  width: min(720px, 100%);
  padding: clamp(1.5rem, 4vw, 3rem);
  padding-bottom: clamp(2.2rem, 7vw, 4.2rem);
  animation: subir 0.9s ease-out both;
}

.marca {
  margin: 0 0 0.4rem;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 700;
  font-size: clamp(2.6rem, 9vw, 4.6rem);
  line-height: 0.92;
  letter-spacing: -0.02em;
  color: #ffd60a;
  text-shadow:
    3px 3px 0 #1d6fbf,
    -1px -1px 0 #1f140c,
    1px -1px 0 #1f140c,
    -1px 1px 0 #1f140c,
    1px 1px 0 #1f140c,
    0 4px 0 rgba(0, 0, 0, 0.2);
  animation: marca-pop 1.1s cubic-bezier(0.22, 1.2, 0.36, 1) both;
}

.titulo {
  margin: 0 0 0.75rem;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 600;
  font-size: clamp(1.4rem, 4.2vw, 2.05rem);
  line-height: 1.15;
  color: #fff8e8;
  text-shadow: 0 2px 0 rgba(31, 20, 12, 0.55);
}

.frase {
  margin: 0 0 1.35rem;
  max-width: 28rem;
  font-size: clamp(1rem, 2.4vw, 1.15rem);
  line-height: 1.45;
  color: #fff3d6;
  text-shadow: 0 1px 2px rgba(31, 20, 12, 0.45);
}

.cta {
  appearance: none;
  border: 3px solid #1f140c;
  cursor: pointer;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 650;
  font-size: 1.15rem;
  padding: 0.85rem 1.7rem;
  border-radius: 16px;
  color: #fff8e8;
  background: linear-gradient(135deg, #e63946 0%, #c62828 100%);
  box-shadow: 0 7px 0 #7a1c1c;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
  animation: cta-pulse 2.4s ease-in-out infinite;
}

.cta:hover {
  transform: translateY(-2px);
  box-shadow: 0 9px 0 #7a1c1c;
}

.cta:active {
  transform: translateY(4px);
  box-shadow: 0 3px 0 #7a1c1c;
  animation: none;
}

@keyframes subir {
  from {
    opacity: 0;
    transform: translateY(28px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes marca-pop {
  from {
    opacity: 0;
    transform: scale(0.86) translateY(12px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
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
  .hero-conteudo {
    padding-left: clamp(2.5rem, 7vw, 5.5rem);
    padding-bottom: clamp(3rem, 6vw, 4.5rem);
  }
}

@media (prefers-reduced-motion: reduce) {
  .hero-conteudo,
  .marca,
  .cta {
    animation: none;
  }
}
</style>
