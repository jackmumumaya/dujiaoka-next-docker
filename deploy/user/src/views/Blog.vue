<template>
  <div
    class="blog-page min-h-screen bg-gray-50 dark:bg-[#0a0a0a] text-gray-900 dark:text-white pt-20 pb-16 relative overflow-hidden">
    <!-- Animated Background -->
    <div class="fixed inset-0 z-0 pointer-events-none">
      <div class="absolute inset-0 bg-[url('/noise.svg')] opacity-20 brightness-100 contrast-150 mix-blend-overlay">
      </div>
      <div class="absolute top-20 left-20 w-[600px] h-[600px] bg-purple-900/10 blur-[120px] rounded-full"></div>
      <div class="absolute bottom-20 right-20 w-[600px] h-[600px] bg-blue-900/10 blur-[120px] rounded-full"></div>
    </div>

    <div class="container mx-auto px-4 relative z-10">
      <!-- Page Header -->
      <div class="mb-16 mt-12 text-center">
        <h1 class="text-4xl md:text-6xl font-black mb-6 tracking-tight">
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-400">
            {{ t('nav.blog') }}
          </span>
        </h1>
        <p
          class="text-gray-600 dark:text-gray-400 max-w-2xl mx-auto text-lg leading-relaxed border-b border-gray-200 dark:border-white/5 pb-8">
          {{ t('blog.subtitle') }}
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div v-for="i in 6" :key="i"
          class="bg-gray-200 dark:bg-[#111] rounded-2xl h-[300px] animate-pulse border border-gray-200 dark:border-white/5">
        </div>
      </div>

      <!-- Posts Grid -->
      <div v-else-if="posts.length > 0">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <article v-for="post in posts" :key="post.id"
            class="group bg-white dark:bg-[#111]/80 backdrop-blur-xl border border-gray-200 dark:border-white/5 rounded-2xl overflow-hidden hover:bg-gray-50 dark:hover:bg-white/5 transition-all duration-300 hover:-translate-y-2 hover:shadow-[0_20px_40px_-20px_rgba(168,85,247,0.15)] cursor-pointer flex flex-col"
            @click="goToPost(post.slug)">
            <!-- Thumbnail -->
            <div v-if="post.thumbnail" class="h-48 overflow-hidden relative">
              <img :src="getImageUrl(post.thumbnail)" :alt="getLocalizedText(post.title)"
                class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
              <div class="absolute inset-0 bg-gradient-to-t from-gray-900 dark:from-[#111] to-transparent opacity-60">
              </div>
            </div>

            <div class="p-8 flex flex-col flex-1">
              <div class="flex items-center justify-between mb-6">
                <span class="text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider border"
                  :class="post.type === 'blog'
                    ? 'bg-purple-100 border-purple-200 text-purple-600 dark:bg-purple-500/10 dark:border-purple-500/20 dark:text-purple-400'
                    : 'bg-blue-100 border-blue-200 text-blue-600 dark:bg-blue-500/10 dark:border-blue-500/20 dark:text-blue-400'">
                  {{ post.type === 'blog' ? t('nav.blog') : t('nav.notice') }}
                </span>
                <time class="text-xs text-gray-500 font-mono">
                  {{ formatDate(post.created_at) }}
                </time>
              </div>

              <h2
                class="text-2xl font-bold mb-4 text-gray-900 dark:text-white group-hover:text-purple-600 dark:group-hover:text-purple-400 transition-colors line-clamp-2 leading-tight">
                {{ getLocalizedText(post.title) }}
              </h2>

              <p class="text-gray-600 dark:text-gray-400 text-sm mb-8 line-clamp-3 leading-relaxed flex-1">
                {{ getLocalizedText(post.summary) }}
              </p>

              <div
                class="flex items-center text-sm font-medium text-gray-400 dark:text-white/50 group-hover:text-gray-900 dark:group-hover:text-white transition-colors mt-auto pt-6 border-t border-gray-100 dark:border-white/5">
                {{ t('blog.readMore') }}
                <svg class="w-4 h-4 ml-2 transition-transform group-hover:translate-x-2" fill="none"
                  stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                </svg>
              </div>
            </div>
          </article>
        </div>

        <!-- Pagination -->
        <div v-if="totalPages > 1" class="mt-16 flex justify-center">
          <nav
            class="flex items-center space-x-2 bg-white dark:bg-[#111]/80 backdrop-blur-md p-2 rounded-2xl border border-gray-200 dark:border-white/5">
            <button @click="changePage(currentPage - 1)" :disabled="currentPage === 1"
              class="w-10 h-10 flex items-center justify-center rounded-xl transition-all disabled:opacity-30 disabled:cursor-not-allowed hover:bg-gray-100 dark:hover:bg-white/10 text-gray-900 dark:text-white">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
            </button>

            <span class="px-4 py-2 font-mono text-gray-500 dark:text-gray-400">
              <span class="text-gray-900 dark:text-white font-bold">{{ currentPage }}</span>
              <span class="mx-2 opacity-50">/</span>
              <span>{{ totalPages }}</span>
            </span>

            <button @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages"
              class="w-10 h-10 flex items-center justify-center rounded-xl transition-all disabled:opacity-30 disabled:cursor-not-allowed hover:bg-gray-100 dark:hover:bg-white/10 text-gray-900 dark:text-white">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          </nav>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else
        class="text-center py-20 border border-gray-200 dark:border-white/5 rounded-2xl bg-white dark:bg-[#111]/50 backdrop-blur-sm">
        <svg class="w-20 h-20 mx-auto text-gray-400 dark:text-gray-600 mb-6" fill="none" stroke="currentColor"
          viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
            d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" />
        </svg>
        <p class="text-gray-500 dark:text-gray-400 text-lg">
          {{ t('blog.empty') }}
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '../stores/app'
import { postAPI } from '../api'
import { getImageUrl } from '../utils/image'
import { debounceAsync } from '../utils/debounce'

const router = useRouter()
const { t } = useI18n()
const appStore = useAppStore()

const loading = ref(true)
const posts = ref<any[]>([])
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)
const totalPages = ref(0)

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

const loadPosts = async () => {
  loading.value = true
  try {
    const response = await postAPI.list({
      type: 'blog',
      page: currentPage.value,
      page_size: pageSize.value,
    })
    posts.value = response.data.data || []
    if (response.data.pagination) {
      total.value = response.data.pagination.total || 0
      totalPages.value = response.data.pagination.total_page || 0
    }
  } catch (error) {
    console.error('Failed to load posts:', error)
  } finally {
    loading.value = false
  }
}

const debouncedLoadPosts = debounceAsync(loadPosts, 300)

const goToPost = (slug: string) => {
  router.push(`/blog/${slug}`)
}

const changePage = (page: number) => {
  if (page < 1 || page > totalPages.value) return
  currentPage.value = page
  debouncedLoadPosts()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(() => {
  debouncedLoadPosts()
})

onUnmounted(() => {
  debouncedLoadPosts.cancel()
})
</script>

<style scoped>
.line-clamp-2 {
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
}

.line-clamp-3 {
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  line-clamp: 3;
}
</style>
