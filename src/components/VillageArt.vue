<template>
  <svg
    class="village"
    viewBox="0 0 800 520"
    xmlns="http://www.w3.org/2000/svg"
    role="img"
    aria-label="Ilustração da vila colorida"
  >
    <defs>
      <linearGradient id="ceu" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#7EC8F0" />
        <stop offset="100%" stop-color="#B8E4F8" />
      </linearGradient>
      <linearGradient id="chao" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0%" stop-color="#8BC34A" />
        <stop offset="100%" stop-color="#5D9B3A" />
      </linearGradient>
    </defs>

    <rect width="800" height="520" fill="url(#ceu)" />

    <g class="nuvem nuvem-a">
      <ellipse cx="120" cy="70" rx="54" ry="22" fill="#fff" opacity="0.9" />
      <ellipse cx="150" cy="66" rx="36" ry="18" fill="#fff" opacity="0.9" />
    </g>
    <g class="nuvem nuvem-b">
      <ellipse cx="620" cy="90" rx="60" ry="24" fill="#fff" opacity="0.85" />
      <ellipse cx="660" cy="86" rx="40" ry="18" fill="#fff" opacity="0.85" />
    </g>

    <circle class="sol" cx="700" cy="70" r="42" fill="#F5C518" />

    <rect y="360" width="800" height="160" fill="url(#chao)" />
    <path d="M0 360 Q200 330 400 360 T800 350 L800 380 L0 380 Z" fill="#7CB342" opacity="0.7" />

    <!-- Casa amarela -->
    <g transform="translate(90,210)">
      <rect width="160" height="150" fill="#F7D154" stroke="#C49A12" stroke-width="4" />
      <polygon points="-10,0 80,-70 170,0" fill="#C45C3E" />
      <rect x="20" y="40" width="40" height="40" fill="#4BA3D9" stroke="#2E6F9A" stroke-width="3" />
      <rect x="100" y="40" width="40" height="40" fill="#4BA3D9" stroke="#2E6F9A" stroke-width="3" />
      <rect x="60" y="90" width="40" height="60" fill="#8B5A2B" />
    </g>

    <!-- Barril geométrico (sem personagem) -->
    <g class="barril" transform="translate(320,265)">
      <ellipse cx="55" cy="140" rx="55" ry="18" fill="#8B5A2B" />
      <rect x="0" y="20" width="110" height="120" rx="20" fill="#E8A54B" stroke="#8B5A2B" stroke-width="4" />
      <ellipse cx="55" cy="20" rx="55" ry="18" fill="#F0C27A" stroke="#8B5A2B" stroke-width="4" />
      <line x1="8" y1="55" x2="102" y2="55" stroke="#8B5A2B" stroke-width="5" />
      <line x1="8" y1="95" x2="102" y2="95" stroke="#8B5A2B" stroke-width="5" />
      <text x="55" y="88" text-anchor="middle" font-family="Baloo 2, sans-serif" font-size="36" font-weight="800" fill="#5C3A1E">2</text>
    </g>

    <!-- Casa azul -->
    <g transform="translate(500,230)">
      <rect width="150" height="130" fill="#5BA4D9" stroke="#2E6F9A" stroke-width="4" />
      <polygon points="-8,0 75,-60 158,0" fill="#C45C3E" />
      <rect x="20" y="35" width="36" height="36" fill="#FFF3B0" stroke="#C49A12" stroke-width="3" />
      <rect x="95" y="35" width="36" height="36" fill="#FFF3B0" stroke="#C49A12" stroke-width="3" />
      <rect x="55" y="80" width="40" height="50" fill="#6B3F1F" />
    </g>

    <!-- Muro de tijolos -->
    <g transform="translate(250,360)">
      <rect width="300" height="36" fill="#D97B5C" />
      <g stroke="#B85A3C" stroke-width="2">
        <line x1="0" y1="18" x2="300" y2="18" />
        <line x1="50" y1="0" x2="50" y2="18" />
        <line x1="100" y1="0" x2="100" y2="18" />
        <line x1="150" y1="0" x2="150" y2="18" />
        <line x1="200" y1="0" x2="200" y2="18" />
        <line x1="250" y1="0" x2="250" y2="18" />
        <line x1="25" y1="18" x2="25" y2="36" />
        <line x1="75" y1="18" x2="75" y2="36" />
        <line x1="125" y1="18" x2="125" y2="36" />
        <line x1="175" y1="18" x2="175" y2="36" />
        <line x1="225" y1="18" x2="225" y2="36" />
        <line x1="275" y1="18" x2="275" y2="36" />
      </g>
    </g>

    <!-- Árvores -->
    <g transform="translate(40,300)">
      <rect x="22" y="50" width="16" height="50" fill="#6B3F1F" />
      <circle cx="30" cy="40" r="34" fill="#4CAF50" />
    </g>
    <g transform="translate(700,310)">
      <rect x="18" y="40" width="14" height="45" fill="#6B3F1F" />
      <circle cx="25" cy="32" r="28" fill="#66BB6A" />
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
}

.nuvem-a {
  animation: flutuar 7s ease-in-out infinite;
}

.nuvem-b {
  animation: flutuar 9s ease-in-out infinite reverse;
}

.sol {
  transform-origin: 700px 70px;
  animation: pulsar-sol 4s ease-in-out infinite;
}

.barril {
  transform-origin: center;
  animation: balancar 3.5s ease-in-out infinite;
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
    transform: scale(1.06);
  }
}

@keyframes balancar {
  0%,
  100% {
    transform: translate(320px, 265px) rotate(-1.5deg);
  }
  50% {
    transform: translate(320px, 265px) rotate(1.5deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .nuvem-a,
  .nuvem-b,
  .sol,
  .barril {
    animation: none;
  }
}
</style>
