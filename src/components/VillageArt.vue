<template>
  <svg
    class="village"
    viewBox="0 0 900 600"
    xmlns="http://www.w3.org/2000/svg"
    role="img"
    aria-label="Ilustração geométrica da vila colorida"
  >
    <defs>
      <linearGradient id="ceu" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#3AA0DE" />
        <stop offset="55%" stop-color="#7EC8F0" />
        <stop offset="100%" stop-color="#B8E4F8" />
      </linearGradient>
      <linearGradient id="chao" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#6BBF45" />
        <stop offset="100%" stop-color="#3F8F2E" />
      </linearGradient>
      <linearGradient id="tijolo" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#E88968" />
        <stop offset="100%" stop-color="#C85A3C" />
      </linearGradient>
      <pattern id="xadrez-verde" width="16" height="16" patternUnits="userSpaceOnUse">
        <rect width="8" height="8" fill="#4CAF50" />
        <rect x="8" y="0" width="8" height="8" fill="#81C784" />
        <rect x="0" y="8" width="8" height="8" fill="#81C784" />
        <rect x="8" y="8" width="8" height="8" fill="#4CAF50" />
      </pattern>
      <pattern id="listra-laranja" width="14" height="14" patternUnits="userSpaceOnUse">
        <rect width="14" height="14" fill="#FF9E5C" />
        <rect width="14" height="7" fill="#FFF3E0" />
      </pattern>
    </defs>

    <!-- Céu full-bleed -->
    <rect width="900" height="600" fill="url(#ceu)" />

    <!-- Sol -->
    <g class="sol">
      <circle cx="780" cy="78" r="48" fill="#FFD60A" stroke="#1F140C" stroke-width="4" />
      <circle cx="780" cy="78" r="34" fill="#FFE566" opacity="0.55" />
    </g>

    <!-- Nuvens -->
    <g class="nuvem nuvem-a" fill="#fff" stroke="#1F140C" stroke-width="3">
      <ellipse cx="110" cy="72" rx="52" ry="22" />
      <ellipse cx="148" cy="66" rx="34" ry="18" />
      <ellipse cx="78" cy="68" rx="28" ry="15" />
    </g>
    <g class="nuvem nuvem-b" fill="#fff" stroke="#1F140C" stroke-width="3">
      <ellipse cx="430" cy="58" rx="48" ry="18" />
      <ellipse cx="468" cy="54" rx="30" ry="14" />
    </g>

    <!-- Prédios da vila (vecindad geométrica) -->
    <g class="predio" transform="translate(40,175)">
      <rect width="210" height="250" fill="url(#tijolo)" stroke="#1F140C" stroke-width="4" />
      <g stroke="#A8462F" stroke-width="2">
        <line x1="0" y1="42" x2="210" y2="42" />
        <line x1="0" y1="84" x2="210" y2="84" />
        <line x1="0" y1="126" x2="210" y2="126" />
        <line x1="0" y1="168" x2="210" y2="168" />
        <line x1="0" y1="210" x2="210" y2="210" />
      </g>
      <!-- Janelas -->
      <rect x="28" y="55" width="48" height="42" rx="4" fill="#9FD8F5" stroke="#1F140C" stroke-width="3" />
      <rect x="128" y="55" width="48" height="42" rx="4" fill="#FFF3B0" stroke="#1F140C" stroke-width="3" />
      <rect x="28" y="140" width="48" height="42" rx="4" fill="#FFF3B0" stroke="#1F140C" stroke-width="3" />
      <rect x="128" y="140" width="48" height="42" rx="4" fill="#9FD8F5" stroke="#1F140C" stroke-width="3" />
      <!-- Porta -->
      <rect x="78" y="195" width="54" height="55" fill="#6B3F1F" stroke="#1F140C" stroke-width="3" />
      <circle cx="120" cy="224" r="4" fill="#FFD60A" />
      <!-- Varal -->
      <line x1="20" y1="30" x2="190" y2="30" stroke="#1F140C" stroke-width="3" />
      <rect class="roupa" x="40" y="18" width="28" height="22" rx="3" fill="#F25CA2" stroke="#1F140C" stroke-width="2" />
      <rect class="roupa" x="90" y="16" width="32" height="24" rx="3" fill="#1D6FBF" stroke="#1F140C" stroke-width="2" />
      <rect class="roupa" x="145" y="19" width="26" height="20" rx="3" fill="#FFD60A" stroke="#1F140C" stroke-width="2" />
    </g>

    <g class="predio" transform="translate(640,195)">
      <rect width="220" height="230" fill="#5BA4D9" stroke="#1F140C" stroke-width="4" />
      <polygon points="-8,0 110,-55 228,0" fill="#E63946" stroke="#1F140C" stroke-width="4" />
      <rect x="30" y="40" width="50" height="44" rx="4" fill="#FFF8E8" stroke="#1F140C" stroke-width="3" />
      <rect x="140" y="40" width="50" height="44" rx="4" fill="#FFD60A" stroke="#1F140C" stroke-width="3" />
      <rect x="30" y="110" width="50" height="44" rx="4" fill="#F25CA2" stroke="#1F140C" stroke-width="3" />
      <rect x="140" y="110" width="50" height="44" rx="4" fill="#FFF8E8" stroke="#1F140C" stroke-width="3" />
      <rect x="82" y="170" width="56" height="60" fill="#6B3F1F" stroke="#1F140C" stroke-width="3" />
    </g>

    <!-- Casa amarela central (fundo) -->
    <g transform="translate(290,210)">
      <rect width="180" height="180" fill="#FFD60A" stroke="#1F140C" stroke-width="4" />
      <polygon points="-12,0 90,-68 192,0" fill="#E63946" stroke="#1F140C" stroke-width="4" />
      <rect x="28" y="45" width="44" height="40" rx="3" fill="#1D6FBF" stroke="#1F140C" stroke-width="3" />
      <rect x="108" y="45" width="44" height="40" rx="3" fill="#1D6FBF" stroke="#1F140C" stroke-width="3" />
      <rect x="68" y="110" width="44" height="70" fill="#A66B2B" stroke="#1F140C" stroke-width="3" />
    </g>

    <!-- Chão / pátio -->
    <rect y="420" width="900" height="180" fill="url(#chao)" />
    <path
      d="M0 420 Q180 392 360 418 T720 405 T900 420 L900 450 L0 450 Z"
      fill="#7CB342"
      opacity="0.85"
    />

    <!-- Muro baixo de tijolos -->
    <g transform="translate(250,408)">
      <rect width="400" height="40" fill="#D96B4C" stroke="#1F140C" stroke-width="3" />
      <g stroke="#A8462F" stroke-width="2">
        <line x1="0" y1="20" x2="400" y2="20" />
        <line x1="50" y1="0" x2="50" y2="20" />
        <line x1="100" y1="0" x2="100" y2="20" />
        <line x1="150" y1="0" x2="150" y2="20" />
        <line x1="200" y1="0" x2="200" y2="20" />
        <line x1="250" y1="0" x2="250" y2="20" />
        <line x1="300" y1="0" x2="300" y2="20" />
        <line x1="350" y1="0" x2="350" y2="20" />
        <line x1="25" y1="20" x2="25" y2="40" />
        <line x1="75" y1="20" x2="75" y2="40" />
        <line x1="125" y1="20" x2="125" y2="40" />
        <line x1="175" y1="20" x2="175" y2="40" />
        <line x1="225" y1="20" x2="225" y2="40" />
        <line x1="275" y1="20" x2="275" y2="40" />
        <line x1="325" y1="20" x2="325" y2="40" />
        <line x1="375" y1="20" x2="375" y2="40" />
      </g>
    </g>

    <!-- Bandeirinhas -->
    <g class="bandeiras" stroke="#1F140C" stroke-width="2.5">
      <path d="M80 140 Q450 95 820 150" fill="none" stroke-width="3" />
      <polygon points="140,132 165,118 165,146" fill="#E63946" />
      <polygon points="220,124 245,110 245,138" fill="#FFD60A" />
      <polygon points="300,116 325,102 325,130" fill="#1D6FBF" />
      <polygon points="380,110 405,96 405,124" fill="#F25CA2" />
      <polygon points="460,108 485,94 485,122" fill="#3D9E3A" />
      <polygon points="540,112 565,98 565,126" fill="#FF8C42" />
      <polygon points="620,120 645,106 645,134" fill="#E63946" />
      <polygon points="700,130 725,116 725,144" fill="#FFD60A" />
    </g>

    <!-- Barril geométrico central (sem personagem) -->
    <g class="barril" transform="translate(385,300)">
      <ellipse cx="65" cy="168" rx="68" ry="18" fill="#6B3F1F" opacity="0.35" />
      <rect x="0" y="28" width="130" height="140" rx="28" fill="#E8A54B" stroke="#1F140C" stroke-width="4" />
      <ellipse cx="65" cy="28" rx="65" ry="20" fill="#F0C27A" stroke="#1F140C" stroke-width="4" />
      <!-- Aros laranja/amarelo -->
      <rect x="4" y="58" width="122" height="12" rx="3" fill="#FF8C42" stroke="#1F140C" stroke-width="2" />
      <rect x="4" y="108" width="122" height="12" rx="3" fill="#FFD60A" stroke="#1F140C" stroke-width="2" />
      <line x1="28" y1="36" x2="28" y2="160" stroke="#A66B2B" stroke-width="3" />
      <line x1="65" y1="36" x2="65" y2="160" stroke="#A66B2B" stroke-width="3" />
      <line x1="102" y1="36" x2="102" y2="160" stroke="#A66B2B" stroke-width="3" />
      <!-- Selo “2” -->
      <circle cx="65" cy="95" r="28" fill="#FFF8E8" stroke="#1F140C" stroke-width="3" />
      <text
        x="65"
        y="106"
        text-anchor="middle"
        font-family="Fredoka, Baloo 2, sans-serif"
        font-size="34"
        font-weight="700"
        fill="#E63946"
      >2</text>
    </g>

    <!-- Motivo geométrico “chapéu xadrez” (abstrato, sem personagem) -->
    <g class="chapeu-motivo" transform="translate(120,455)">
      <ellipse cx="36" cy="28" rx="40" ry="14" fill="url(#xadrez-verde)" stroke="#1F140C" stroke-width="3" />
      <rect x="8" y="0" width="56" height="28" rx="8" fill="url(#xadrez-verde)" stroke="#1F140C" stroke-width="3" />
      <rect x="20" y="-10" width="14" height="14" rx="3" fill="#81C784" stroke="#1F140C" stroke-width="2" />
      <rect x="38" y="-10" width="14" height="14" rx="3" fill="#4CAF50" stroke="#1F140C" stroke-width="2" />
    </g>

    <!-- Motivo camisa listrada abstrato -->
    <g transform="translate(720,460)">
      <rect width="70" height="48" rx="10" fill="url(#listra-laranja)" stroke="#1F140C" stroke-width="3" />
    </g>

    <!-- Árvores -->
    <g transform="translate(20,360)">
      <rect x="26" y="55" width="16" height="55" fill="#6B3F1F" stroke="#1F140C" stroke-width="2" />
      <circle cx="34" cy="42" r="36" fill="#3D9E3A" stroke="#1F140C" stroke-width="3" />
      <circle cx="18" cy="50" r="18" fill="#66BB6A" stroke="#1F140C" stroke-width="2" />
    </g>
    <g transform="translate(830,370)">
      <rect x="20" y="45" width="14" height="50" fill="#6B3F1F" stroke="#1F140C" stroke-width="2" />
      <circle cx="27" cy="36" r="30" fill="#66BB6A" stroke="#1F140C" stroke-width="3" />
    </g>
  </svg>
</template>

<script>
export default {
  name: 'VillageArt',
}
</script>

<style scoped>
.village {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
}

.nuvem-a {
  animation: flutuar 7s ease-in-out infinite;
}

.nuvem-b {
  animation: flutuar 9s ease-in-out infinite reverse;
}

.sol {
  transform-origin: 780px 78px;
  animation: pulsar-sol 4s ease-in-out infinite;
}

.barril {
  transform-origin: center;
  animation: balancar 3.5s ease-in-out infinite;
}

.bandeiras {
  animation: tremer-leve 5s ease-in-out infinite;
  transform-origin: 450px 120px;
}

.roupa {
  animation: balancar-roupa 2.8s ease-in-out infinite;
  transform-box: fill-box;
  transform-origin: top center;
}

@keyframes flutuar {
  0%,
  100% {
    transform: translateX(0);
  }
  50% {
    transform: translateX(18px);
  }
}

@keyframes pulsar-sol {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.07);
  }
}

@keyframes balancar {
  0%,
  100% {
    transform: translate(385px, 300px) rotate(-1.8deg);
  }
  50% {
    transform: translate(385px, 300px) rotate(1.8deg);
  }
}

@keyframes tremer-leve {
  0%,
  100% {
    transform: rotate(0deg);
  }
  50% {
    transform: rotate(0.6deg);
  }
}

@keyframes balancar-roupa {
  0%,
  100% {
    transform: rotate(-4deg);
  }
  50% {
    transform: rotate(5deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .nuvem-a,
  .nuvem-b,
  .sol,
  .barril,
  .bandeiras,
  .roupa {
    animation: none;
  }
}
</style>
