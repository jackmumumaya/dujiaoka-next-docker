<template>
  <div
    class="min-h-screen bg-gray-50 dark:bg-[#050505] text-gray-900 dark:text-white flex flex-col relative overflow-hidden">
    <!-- Background Decor -->
    <div
      class="absolute top-0 left-1/4 w-[500px] h-[500px] bg-purple-900/10 blur-[120px] rounded-full pointer-events-none">
    </div>
    <div
      class="absolute bottom-1/4 right-0 w-[500px] h-[500px] bg-blue-900/10 blur-[120px] rounded-full pointer-events-none">
    </div>

    <!-- Navbar is global -->

    <div class="flex-1 container mx-auto px-4 py-20 max-w-4xl relative z-10 mt-12">
      <div v-if="loading" class="flex justify-center py-20">
        <div class="w-10 h-10 border-2 border-purple-500 border-t-transparent rounded-full animate-spin"></div>
      </div>

      <div v-else
        class="bg-white dark:bg-white/5 backdrop-blur-xl border border-gray-200 dark:border-white/10 rounded-3xl p-8 md:p-12 shadow-2xl">
        <h1
          class="text-3xl md:text-4xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-gray-900 to-gray-500 dark:from-white dark:to-gray-400 mb-10 border-b border-gray-100 dark:border-white/10 pb-6 tracking-tight">
          {{ title }}
        </h1>

        <div
          class="prose prose-gray dark:prose-invert prose-lg max-w-none prose-headings:font-bold prose-headings:tracking-tight prose-a:text-purple-600 dark:prose-a:text-purple-400 prose-a:no-underline hover:prose-a:text-purple-500 dark:hover:prose-a:text-purple-300 transition-colors"
          v-html="content"></div>

        <div v-if="!content" class="text-center text-gray-500 py-20 flex flex-col items-center">
          <svg class="w-12 h-12 mb-4 text-gray-400 dark:text-gray-700" fill="none" stroke="currentColor"
            viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <p class="text-lg font-medium">暂无内容 / No Content</p>
          <p class="text-sm mt-2 opacity-60">Please configure this page in Admin Panel</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useAppStore } from '../stores/app'

const props = defineProps<{
  type: 'terms' | 'privacy'
}>()

const appStore = useAppStore()

const loading = computed(() => appStore.loading)
const locale = computed(() => appStore.locale)

const title = computed(() => {
  if (props.type === 'terms') {
    return locale.value === 'zh-CN' ? '服务条款' : (locale.value === 'zh-TW' ? '服務條款' : 'Terms of Service')
  } else {
    return locale.value === 'zh-CN' ? '隐私政策' : (locale.value === 'zh-TW' ? '隱私政策' : 'Privacy Policy')
  }
})

const content = computed(() => {
  const config = appStore.config
  if (!config?.legal) return ''

  const legal = config.legal
  const lang = locale.value

  if (props.type === 'terms' && legal.terms) {
    return legal.terms[lang] || ''
  } else if (props.type === 'privacy' && legal.privacy) {
    return legal.privacy[lang] || ''
  }
  return ''
})
</script>

<style scoped>
/* Tailwind Typography (prose) handles formatting */
</style>
