<template>
  <div
    class="notice-page min-h-screen bg-gray-50 dark:bg-[#0a0a0a] text-gray-900 dark:text-white pt-20 pb-16 relative overflow-hidden">
    <!-- Animated Background -->
    <div class="fixed inset-0 z-0 pointer-events-none">
      <div class="absolute inset-0 bg-[url('/noise.svg')] opacity-20 brightness-100 contrast-150 mix-blend-overlay">
      </div>
      <div class="absolute top-20 right-20 w-[600px] h-[600px] bg-blue-900/10 blur-[120px] rounded-full"></div>
      <div class="absolute bottom-20 left-20 w-[600px] h-[600px] bg-purple-900/10 blur-[120px] rounded-full"></div>
    </div>

    <div class="container mx-auto px-4 relative z-10">
      <!-- Page Header -->
      <div class="mb-16 mt-12 text-center">
        <h1 class="text-4xl md:text-6xl font-black mb-6 tracking-tight">
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-purple-400">
            {{ t('nav.notice') }}
          </span>
        </h1>
        <p
          class="text-gray-600 dark:text-gray-400 max-w-2xl mx-auto text-lg leading-relaxed border-b border-gray-200 dark:border-white/5 pb-8">
          {{ t('notice.subtitle') }}
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="space-y-4 max-w-4xl mx-auto">
        <div v-for="i in 6" :key="i"
          class="bg-gray-200 dark:bg-[#111] rounded-2xl h-32 animate-pulse border border-gray-200 dark:border-white/5">
        </div>
      </div>

      <!-- Notices List -->
      <div v-else-if="notices.length > 0" class="max-w-4xl mx-auto space-y-4">
        <article v-for="notice in notices" :key="notice.id"
          class="group bg-white dark:bg-[#111]/80 backdrop-blur-xl border border-gray-200 dark:border-white/5 rounded-2xl p-6 md:p-8 hover:bg-gray-50 dark:hover:bg-white/5 transition-all duration-300 hover:-translate-x-2 hover:translate-y-0 hover:shadow-[0_10px_30px_-10px_rgba(59,130,246,0.15)] cursor-pointer flex items-center gap-6"
          @click="goToNotice(notice.slug)">
          <!-- Icon Column -->
          <div
            class="hidden sm:flex flex-shrink-0 w-16 h-16 rounded-xl overflow-hidden bg-blue-50 dark:bg-blue-500/10 border border-blue-100 dark:border-blue-500/20 items-center justify-center text-blue-600 dark:text-blue-400 group-hover:scale-110 transition-transform">
            <img v-if="notice.thumbnail" :src="getImageUrl(notice.thumbnail)" :alt="getLocalizedText(notice.title)"
              class="w-full h-full object-cover">
            <svg v-else class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
            </svg>
          </div>

          <!-- Content -->
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-3 mb-2">
              <span
                class="text-xs font-bold px-2 py-0.5 rounded text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-500/10 border border-blue-100 dark:border-blue-500/20 uppercase tracking-wider">
                {{ t('nav.notice') }}
              </span>
              <time class="text-xs text-gray-500 font-mono">
                {{ formatDate(notice.created_at) }}
              </time>
            </div>

            <h2
              class="text-xl font-bold text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors truncate mb-1">
              {{ getLocalizedText(notice.title) }}
            </h2>

            <p class="text-gray-600 dark:text-gray-400 text-sm line-clamp-1">
              {{ getLocalizedText(notice.summary) }}
            </p>
          </div>

          <!-- Arrow -->
          <div
            class="flex-shrink-0 text-gray-400 dark:text-gray-500 group-hover:text-gray-900 dark:group-hover:text-white transition-colors group-hover:translate-x-1 duration-300">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
            </svg>
          </div>
        </article>

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
        class="text-center py-20 border border-gray-200 dark:border-white/5 rounded-2xl bg-white dark:bg-[#111]/50 backdrop-blur-sm max-w-4xl mx-auto">
        <svg class="w-20 h-20 mx-auto text-gray-400 dark:text-gray-600 mb-6" fill="none" stroke="currentColor"
          viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
            d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
        <p class="text-gray-500 dark:text-gray-400 text-lg">
          {{ t('notice.empty') }}
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
const notices = ref<any[]>([])
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

const loadNotices = async () => {
  loading.value = true
  try {
    const response = await postAPI.list({
      type: 'notice',
      page: currentPage.value,
      page_size: pageSize.value,
    })
    notices.value = response.data.data || []
    if (response.data.pagination) {
      total.value = response.data.pagination.total || 0
      totalPages.value = response.data.pagination.total_page || 0
    }
  } catch (error) {
    console.error('Failed to load notices:', error)
  } finally {
    loading.value = false
  }
}

const debouncedLoadNotices = debounceAsync(loadNotices, 300)

const goToNotice = (slug: string) => {
  router.push(`/blog/${slug}`) // 使用同一个详情页
}

const changePage = (page: number) => {
  if (page < 1 || page > totalPages.value) return
  currentPage.value = page
  debouncedLoadNotices()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

onMounted(() => {
  debouncedLoadNotices()
})

onUnmounted(() => {
  debouncedLoadNotices.cancel()
})
</script>

<style scoped>
.line-clamp-1 {
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 1;
  line-clamp: 1;
}
</style>
