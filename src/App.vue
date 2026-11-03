<template>
  <div class="site">
    <HeroSection :config="config" @confirmar="irParaRsvp" />
    <LocalSection :config="config" />
    <RsvpSection ref="rsvp" :config="config" />
    <footer class="rodape">
      <p>{{ config.marca }} · {{ config.nomeAniversariante }} faz {{ config.idade }} anos</p>
      <a class="rodape-admin" :href="adminHref">Área da família</a>
    </footer>
  </div>
</template>

<script>
import config from './config.js'
import HeroSection from './components/HeroSection.vue'
import LocalSection from './components/LocalSection.vue'
import RsvpSection from './components/RsvpSection.vue'

export default {
  name: 'App',
  components: {
    HeroSection,
    LocalSection,
    RsvpSection,
  },
  data() {
    return {
      config,
    }
  },
  computed: {
    adminHref() {
      const base = import.meta.env.BASE_URL || '/'
      return `${base}admin/`
    },
  },
  methods: {
    irParaRsvp() {
      const el = this.$refs.rsvp && this.$refs.rsvp.$el
      if (el && typeof el.scrollIntoView === 'function') {
        el.scrollIntoView({ behavior: 'smooth', block: 'start' })
      }
    },
  },
}
</script>
