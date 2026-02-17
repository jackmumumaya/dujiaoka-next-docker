<template>
  <div
    class="blog-detail-page min-h-screen bg-gray-50 dark:bg-[#0a0a0a] text-gray-900 dark:text-white pt-24 pb-16 relative overflow-hidden">
    <!-- Animated Background -->
    <div class="fixed inset-0 z-0 pointer-events-none">
      <div class="absolute inset-0 bg-[url('/noise.svg')] opacity-20 brightness-100 contrast-150 mix-blend-overlay">
      </div>
      <div
        class="absolute top-0 right-1/4 w-[500px] h-[500px] bg-purple-500/10 dark:bg-purple-900/10 blur-[120px] rounded-full">
      </div>
      <div
        class="absolute bottom-0 left-1/4 w-[500px] h-[500px] bg-blue-500/10 dark:bg-blue-900/10 blur-[120px] rounded-full">
      </div>
    </div>

    <div class="container mx-auto px-4 max-w-4xl relative z-10">
      <!-- Loading State -->
      <div v-if="loading" class="animate-pulse space-y-8">
        <div class="h-8 bg-gray-200 dark:bg-gray-800 rounded w-1/3"></div>
        <div class="space-y-4">
          <div class="h-12 bg-gray-200 dark:bg-gray-800 rounded w-3/4"></div>
          <div class="h-6 bg-gray-200 dark:bg-gray-800 rounded w-1/2"></div>
        </div>
        <div class="h-96 bg-gray-200 dark:bg-gray-800 rounded-3xl"></div>
      </div>

      <!-- Post Content -->
      <article v-else-if="post">
        <!-- Breadcrumb -->
        <nav class="mb-8 flex items-center space-x-2 text-sm text-gray-500 dark:text-gray-500 font-medium">
          <router-link to="/" class="hover:text-gray-900 dark:hover:text-white transition-colors">{{ t('nav.home')
          }}</router-link>
          <span>/</span>
          <router-link :to="backLink" class="hover:text-gray-900 dark:hover:text-white transition-colors">{{ backText
          }}</router-link>
          <span>/</span>
          <span class="text-gray-900 dark:text-white truncate max-w-[200px]">{{ getLocalizedText(post.title) }}</span>
        </nav>

        <div
          class="bg-white dark:bg-[#111]/80 backdrop-blur-xl border border-gray-200 dark:border-white/5 rounded-3xl p-8 md:p-12 shadow-2xl relative overflow-hidden">
          <!-- Top Glow -->
          <div
            class="absolute top-0 left-1/2 -translate-x-1/2 w-2/3 h-1 bg-gradient-to-r from-transparent via-purple-500 to-transparent opacity-50">
          </div>

          <!-- Featured Image -->
          <div v-if="post.thumbnail" class="mb-12 relative h-64 md:h-96 rounded-2xl overflow-hidden group">
            <img :src="getImageUrl(post.thumbnail)" :alt="getLocalizedText(post.title)"
              class="w-full h-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-t from-black/10 to-transparent dark:from-[#111]/80"></div>
          </div>

          <!-- Post Header -->
          <header class="mb-12 border-b border-gray-100 dark:border-white/5 pb-12">
            <div class="flex flex-wrap items-center gap-4 mb-6">
              <span class="text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider border" :class="post.type === 'blog'
                ? 'bg-purple-500/10 border-purple-500/20 text-purple-400'
                : 'bg-blue-500/10 border-blue-500/20 text-blue-600 dark:text-blue-400'">
                {{ post.type === 'blog' ? t('nav.blog') : t('nav.notice') }}
              </span>
              <time class="text-sm text-gray-500 font-mono">
                {{ formatDate(post.created_at) }}
              </time>
            </div>

            <h1 class="text-3xl md:text-5xl font-black text-gray-900 dark:text-white mb-6 leading-tight tracking-tight">
              {{ getLocalizedText(post.title) }}
            </h1>

            <p v-if="post.summary" class="text-xl text-gray-600 dark:text-gray-400 leading-relaxed font-light">
              {{ getLocalizedText(post.summary) }}
            </p>
          </header>

          <!-- Post Content -->
          <div v-html="processHtmlForDisplay(getLocalizedText(post.content))"
            class="prose prose-lg max-w-none dark:prose-invert prose-headings:text-gray-900 dark:prose-headings:text-white prose-a:text-purple-600 dark:prose-a:text-purple-400 hover:prose-a:text-purple-500 dark:hover:prose-a:text-purple-300 prose-strong:text-gray-900 dark:prose-strong:text-white prose-blockquote:border-purple-500 prose-blockquote:bg-gray-50 dark:prose-blockquote:bg-white/5 prose-blockquote:p-4 prose-blockquote:rounded-r-lg prose-blockquote:text-gray-600 dark:prose-blockquote:text-gray-300">
          </div>

          <!-- Footer -->
          <footer class="mt-16 pt-12 border-t border-gray-100 dark:border-white/5 flex justify-center">
            <router-link :to="backLink"
              class="group inline-flex items-center space-x-3 text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white transition-colors px-6 py-3 border border-gray-200 dark:border-white/5 rounded-full hover:bg-gray-50 dark:hover:bg-white/5">
              <svg class="w-5 h-5 transition-transform group-hover:-translate-x-1" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
              </svg>
              <span class="font-medium">{{ backText }}</span>
            </router-link>
          </footer>
        </div>
      </article>

      <!-- Error State -->
      <div v-else
        class="text-center py-24 bg-white dark:bg-[#111]/50 rounded-3xl border border-gray-200 dark:border-white/5 backdrop-blur-sm shadow-xl dark:shadow-none">
        <svg class="w-20 h-20 mx-auto text-gray-400 dark:text-gray-600 mb-6" fill="none" stroke="currentColor"
          viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
            d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p class="text-gray-500 dark:text-gray-400 text-xl mb-8">
          {{ t('blogDetail.notFound') }}
        </p>
        <router-link to="/blog"
          class="inline-block bg-gray-900 text-white dark:bg-white dark:text-black px-8 py-3 rounded-full font-bold hover:scale-105 transition-transform shadow-lg shadow-gray-200 dark:shadow-none">
          {{ t('blogDetail.backToBlog') }}
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '../stores/app'
import { postAPI } from '../api'
import { getImageUrl } from '../utils/image'
import { processHtmlForDisplay } from '../utils/content'
import { debounceAsync } from '../utils/debounce'

const route = useRoute()
const { t } = useI18n()
const appStore = useAppStore()

const loading = ref(true)
const post = ref<any>(null)

const getLocalizedText = (jsonData: any) => {
  if (!jsonData) return ''
  const locale = appStore.locale
  return jsonData[locale] || jsonData['zh-CN'] || jsonData['en-US'] || ''
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString(appStore.locale, {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

const backLink = computed(() => {
  if (!post.value) return '/blog'
  return post.value.type === 'notice' ? '/notice' : '/blog'
})

const backText = computed(() => {
  if (!post.value) return t('blogDetail.backToBlog')
  return post.value.type === 'notice' ? t('blogDetail.backToNotice') : t('blogDetail.backToBlog')
})

const loadPost = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    const response = await postAPI.detail(slug)
    post.value = response.data.data || null
  } catch (error) {
    console.error('Failed to load post:', error)
    post.value = null
  } finally {
    loading.value = false
  }
}

const debouncedLoadPost = debounceAsync(loadPost, 300)

onMounted(() => {
  debouncedLoadPost()
})

onUnmounted(() => {
  debouncedLoadPost.cancel()
})
</script>
