<template>
  <header class="hero">
    <div class="hero-visual" aria-hidden="true">
      <img
        class="hero-fundo"
        :src="fundoSrc"
        alt=""
        width="1024"
        height="724"
      />
      <div class="hero-vinheta" />
    </div>
    <div class="hero-conteudo">
      <p class="marca">{{ config.marca }}</p>
      <h1 class="titulo">{{ config.nomeAniversariante }} faz {{ config.idade }} anos!</h1>
      <p class="frase">Venha brincar na nossa vila — a festa fica completa com você.</p>
      <button type="button" class="cta" @click="$emit('confirmar')">
        Confirmar presença
      </button>
    </div>
  </header>
</template>

<script>
export default {
  name: 'HeroSection',
  props: {
    config: {
      type: Object,
      required: true,
    },
  },
  emits: ['confirmar'],
  computed: {
    fundoSrc() {
      const base = import.meta.env.BASE_URL || '/'
      return `${base}images/turma-do-chaves-desenho.png`
    },
  },
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
  background: #5bb8e8;
}

.hero-visual {
  position: absolute;
  inset: 0;
  z-index: 0;
}

.hero-fundo {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 28%;
  animation: zoom-leve 18s ease-in-out infinite alternate;
}

.hero-vinheta {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background:
    linear-gradient(
      180deg,
      rgba(20, 12, 8, 0.22) 0%,
      rgba(20, 12, 8, 0.08) 28%,
      rgba(20, 12, 8, 0.35) 58%,
      rgba(20, 12, 8, 0.72) 100%
    ),
    radial-gradient(ellipse at 35% 85%, rgba(255, 214, 10, 0.14), transparent 50%);
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
    0 4px 12px rgba(0, 0, 0, 0.45);
  animation: marca-pop 1.1s cubic-bezier(0.22, 1.2, 0.36, 1) both;
}

.titulo {
  margin: 0 0 0.75rem;
  font-family: 'Fredoka', 'Baloo 2', sans-serif;
  font-weight: 600;
  font-size: clamp(1.4rem, 4.2vw, 2.05rem);
  line-height: 1.15;
  color: #fff8e8;
  text-shadow:
    0 2px 0 rgba(31, 20, 12, 0.75),
    0 4px 16px rgba(0, 0, 0, 0.5);
}

.frase {
  margin: 0 0 1.35rem;
  max-width: 28rem;
  font-size: clamp(1rem, 2.4vw, 1.15rem);
  line-height: 1.45;
  color: #fff3d6;
  text-shadow:
    0 1px 2px rgba(31, 20, 12, 0.65),
    0 2px 12px rgba(0, 0, 0, 0.4);
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
  box-shadow:
    0 7px 0 #7a1c1c,
    0 10px 24px rgba(0, 0, 0, 0.35);
  transition: transform 0.15s ease, box-shadow 0.15s ease;
  animation: cta-pulse 2.4s ease-in-out infinite;
}

.cta:hover {
  transform: translateY(-2px);
  box-shadow:
    0 9px 0 #7a1c1c,
    0 12px 28px rgba(0, 0, 0, 0.4);
}

.cta:active {
  transform: translateY(4px);
  box-shadow:
    0 3px 0 #7a1c1c,
    0 6px 16px rgba(0, 0, 0, 0.3);
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

@keyframes zoom-leve {
  from {
    transform: scale(1);
  }
  to {
    transform: scale(1.06);
  }
}

@media (min-width: 900px) {
  .hero-conteudo {
    padding-left: clamp(2.5rem, 7vw, 5.5rem);
    padding-bottom: clamp(3rem, 6vw, 4.5rem);
  }

  .hero-fundo {
    object-position: center 22%;
  }
}

/* Mobile: arte completa (altura natural, sem crop do cover) */
@media (max-width: 899px) {
  .hero {
    min-height: 0;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    overflow: visible;
  }

  .hero-visual {
    position: relative;
    inset: auto;
    flex: 0 0 auto;
  }

  .hero-fundo {
    width: 100%;
    height: auto;
    object-fit: contain;
    object-position: center top;
    animation: none;
  }

  .hero-vinheta {
    background:
      linear-gradient(
        180deg,
        rgba(20, 12, 8, 0.08) 0%,
        rgba(20, 12, 8, 0.05) 45%,
        rgba(20, 12, 8, 0.55) 78%,
        rgba(20, 12, 8, 0.88) 100%
      ),
      radial-gradient(ellipse at 35% 85%, rgba(255, 214, 10, 0.12), transparent 50%);
  }

  .hero-conteudo {
    width: 100%;
    margin-top: -3.25rem;
    padding-top: 2rem;
    background: linear-gradient(
      180deg,
      rgba(20, 12, 8, 0.9) 0%,
      rgba(20, 12, 8, 0.5) 62%,
      transparent 100%
    );
  }
}

@media (prefers-reduced-motion: reduce) {
  .hero-conteudo,
  .marca,
  .cta,
  .hero-fundo {
    animation: none;
  }
}
</style>
