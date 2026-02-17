<template>
  <transition name="fade">
    <div v-if="loading"
      class="fixed inset-0 z-50 flex items-center justify-center bg-white/90 dark:bg-[#0a0a0a]/90 backdrop-blur-xl transition-all duration-500">
      <!-- Background Glow -->
      <div class="absolute inset-0 pointer-events-none overflow-hidden">
        <div
          class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-purple-500/10 dark:bg-purple-600/10 blur-[100px] rounded-full animate-pulse-slow">
        </div>
      </div>

      <div class="relative flex flex-col items-center gap-8">
        <!-- Tech Spinner -->
        <div class="relative w-24 h-24">
          <!-- Outer Ring -->
          <div class="absolute inset-0 rounded-full border border-gray-200 dark:border-white/10"></div>

          <!-- Spinning Gradient Ring -->
          <div
            class="absolute inset-0 rounded-full border-2 border-transparent border-t-purple-500 border-r-blue-500 animate-spin shadow-[0_0_20px_rgba(168,85,247,0.5)]">
          </div>

          <!-- Inner Pulse -->
          <div
            class="absolute inset-4 rounded-full bg-gray-100 dark:bg-white/5 animate-pulse flex items-center justify-center backdrop-blur-sm border border-gray-200 dark:border-white/10">
            <div
              class="w-2 h-2 bg-gray-900 dark:bg-white rounded-full shadow-[0_0_10px_rgba(0,0,0,0.5)] dark:shadow-[0_0_10px_white]">
            </div>
          </div>

          <!-- Reverse Spinner -->
          <div
            class="absolute inset-[-10px] rounded-full border border-transparent border-b-purple-500/30 animate-spin-reverse">
          </div>
        </div>

        <!-- Text -->
        <div class="flex flex-col items-center gap-2">
          <div class="text-xl font-bold tracking-[0.2em] text-gray-900 dark:text-white animate-pulse">
            LOADING
          </div>
          <div class="flex gap-1 h-1">
            <div class="w-1 h-1 bg-purple-500 rounded-full animate-bounce delay-100"></div>
            <div class="w-1 h-1 bg-purple-500 rounded-full animate-bounce delay-200"></div>
            <div class="w-1 h-1 bg-purple-500 rounded-full animate-bounce delay-300"></div>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
defineProps<{
  loading: boolean
}>()
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.animate-spin-reverse {
  animation: spin-reverse 3s linear infinite;
}

.animate-pulse-slow {
  animation: pulse-slow 4s ease-in-out infinite;
}

@keyframes spin-reverse {
  from {
    transform: rotate(360deg);
  }

  to {
    transform: rotate(0deg);
  }
}

@keyframes pulse-slow {

  0%,
  100% {
    opacity: 0.3;
    transform: translate(-50%, -50%) scale(1);
  }

  50% {
    opacity: 0.5;
    transform: translate(-50%, -50%) scale(1.1);
  }
}

.delay-100 {
  animation-delay: 0.1s;
}

.delay-200 {
  animation-delay: 0.2s;
}

.delay-300 {
  animation-delay: 0.3s;
}
</style>
