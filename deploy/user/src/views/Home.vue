<template>
  <div class="home-page min-h-screen bg-gray-50 text-gray-900 dark:bg-[#0a0a0a] dark:text-white">
    <div class="fixed inset-0 z-0 pointer-events-none">
      <div class="absolute inset-0 bg-[url('/noise.svg')] opacity-20 mix-blend-overlay"></div>
      <div class="absolute top-[-10%] left-[-10%] h-[40%] w-[40%] rounded-full bg-purple-600/20 blur-[120px]"></div>
      <div class="absolute right-[-10%] bottom-[-10%] h-[40%] w-[40%] rounded-full bg-blue-600/20 blur-[120px]"></div>
    </div>

    <section class="relative z-10 border-b border-gray-200/70 pt-24 pb-10 dark:border-white/10">
      <div class="container mx-auto px-4">
        <div class="relative overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-xl dark:border-white/10 dark:bg-white/5">
          <img v-if="!bannerLoading && heroImage" :src="heroImage" class="absolute inset-0 h-full w-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-r from-black/70 via-black/45 to-black/20"></div>

          <div v-if="bannerLoading" class="relative flex min-h-[420px] flex-col justify-between p-8 md:p-12">
            <div class="mb-4 flex items-center justify-end">
              <span class="inline-flex items-center rounded-full border border-white/30 bg-black/30 px-3 py-1 text-xs font-medium text-white/90">
                {{ t('common.loading') }}
              </span>
            </div>

            <div class="space-y-4">
              <div class="h-6 w-28 animate-pulse rounded-full bg-white/35"></div>
              <div class="h-10 max-w-4xl animate-pulse rounded-xl bg-white/35 md:h-14"></div>
              <div class="h-5 max-w-3xl animate-pulse rounded-lg bg-white/30"></div>
            </div>

            <div class="flex flex-wrap items-center gap-3 pt-6">
              <div class="h-11 w-36 animate-pulse rounded-lg bg-white/35"></div>
              <div class="h-11 w-28 animate-pulse rounded-lg bg-white/25"></div>
            </div>
          </div>

          <div v-else class="relative flex min-h-[420px] flex-col justify-between p-8 md:p-12">
            <div v-if="bannerCount > 1" class="mb-4 flex items-center justify-end gap-2">
              <button
                type="button"
                class="inline-flex h-9 w-9 items-center justify-center rounded-full border border-white/30 bg-black/20 text-white transition hover:bg-black/35"
                @click="handlePrevHeroBanner"
                aria-label="上一张 Banner"
              >
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
              </button>
              <button
                type="button"
                class="inline-flex h-9 w-9 items-center justify-center rounded-full border border-white/30 bg-black/20 text-white transition hover:bg-black/35"
                @click="handleNextHeroBanner"
                aria-label="下一张 Banner"
              >
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </button>
            </div>

            <div class="space-y-4">
              <span class="inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold uppercase tracking-wider text-white backdrop-blur">
                <span class="h-2 w-2 rounded-full bg-emerald-300"></span>
                {{ heroBadge }}
              </span>
              <h1 class="max-w-4xl text-3xl font-black leading-tight text-white md:text-5xl">
                {{ heroTitle }}
              </h1>
              <p class="max-w-3xl text-sm leading-relaxed text-gray-100 md:text-base">
                {{ heroSubtitle }}
              </p>
            </div>

            <div class="flex flex-wrap items-center gap-3 pt-6">
              <button
                type="button"
                @click="goToHeroLink"
                class="inline-flex items-center gap-2 rounded-lg bg-white px-5 py-3 text-sm font-semibold text-gray-900 transition hover:scale-105"
              >
                {{ heroPrimaryButtonText }}
                <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                </svg>
              </button>
              <router-link
                v-if="!hasHeroLink"
                to="/products"
                class="inline-flex items-center rounded-lg border border-white/30 px-5 py-3 text-sm font-medium text-white transition hover:border-white hover:bg-white/10"
              >
                {{ t('home.featured.viewAll') }}
              </router-link>
            </div>

            <div v-if="bannerCount > 1" class="mt-5 flex items-center gap-2">
              <button
                v-for="(_, index) in banners"
                :key="`hero-dot-${index}`"
                type="button"
                class="h-2.5 rounded-full transition-all"
                :class="index === currentBannerIndex ? 'w-7 bg-white' : 'w-2.5 bg-white/45 hover:bg-white/70'"
                @click="selectHeroBanner(index)"
                :aria-label="`切换到第 ${index + 1} 张 Banner`"
              ></button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section id="featured" class="relative z-10 py-14">
      <div class="container mx-auto px-4">
        <div class="mb-8 flex items-end justify-between gap-4">
          <div>
            <h2 class="text-3xl font-black tracking-tight md:text-4xl">{{ t('home.featured.title') }}</h2>
            <p class="mt-2 text-sm text-gray-600 dark:text-gray-300">{{ t('home.featured.description') }}</p>
          </div>
          <router-link
                v-if="!hasHeroLink"
                to="/products"
            class="text-sm font-semibold text-gray-700 transition hover:text-black dark:text-gray-300 dark:hover:text-white"
          >
            {{ t('home.featured.viewAll') }}
          </router-link>
        </div>

        <div v-if="products.length > 0" class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
          <article
            v-for="product in products"
            :key="product.id"
            class="group cursor-pointer overflow-hidden rounded-2xl border border-gray-200 bg-white shadow-sm transition dark:border-white/10 dark:bg-white/5 flex h-full flex-col"
            :class="isSoldOut(product)
              ? 'opacity-85 grayscale-[0.25] saturate-50 border-rose-300/60 dark:border-rose-900/40 hover:-translate-y-0 hover:shadow-sm'
              : 'hover:-translate-y-1 hover:shadow-lg'"
            @click="goToProduct(product.slug)"
          >
            <div class="relative h-56 overflow-hidden bg-gray-100 dark:bg-black/40 shrink-0">
              <img
                v-if="product.images && getFirstImageUrl(product.images)"
                :src="getFirstImageUrl(product.images)"
                :alt="getLocalizedText(product.title)"
                class="h-full w-full object-cover transition duration-500"
                :class="isSoldOut(product) ? 'grayscale brightness-75' : 'group-hover:scale-105'"
              />
              <div v-else class="flex h-full items-center justify-center text-sm text-gray-400">{{ t('home.featured.empty') }}</div>

              <div v-if="isSoldOut(product)" class="absolute inset-0 z-10 bg-black/45"></div>
              <div
                v-if="isSoldOut(product)"
                class="absolute left-3 top-3 z-20 inline-flex items-center rounded-full border border-rose-300/70 bg-rose-600 px-2.5 py-1 text-[11px] font-bold tracking-wider text-white shadow-lg"
              >
                {{ t('products.stockStatus.outOfStock') }}
              </div>

              <div v-if="!isSoldOut(product) && product.tags && product.tags.length > 0" class="absolute right-3 top-3 flex max-w-[70%] flex-wrap justify-end gap-1.5">
                <span
                  v-for="(tag, index) in product.tags.slice(0, 2)"
                  :key="index"
                  class="rounded-full border border-white/20 bg-black/60 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur"
                >
                  {{ tag }}
                </span>
              </div>
            </div>
            <div class="space-y-2 p-5">
              <h3 class="line-clamp-1 text-base font-semibold text-gray-900 dark:text-white">{{ getLocalizedText(product.title) }}</h3>

              <div class="flex flex-wrap items-center gap-2">
                <span
                  class="inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-semibold"
                  :class="product.purchase_type === 'guest'
                    ? 'border-amber-500/40 bg-amber-500/12 text-amber-700 dark:text-amber-300'
                    : 'border-emerald-500/40 bg-emerald-500/12 text-emerald-700 dark:text-emerald-300'"
                >
                  <svg v-if="product.purchase_type === 'guest'" class="mr-1 h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 21v-2a4 4 0 00-4-4H7a4 4 0 00-4 4v2" />
                    <circle cx="9.5" cy="7" r="3" stroke-width="2" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 8l2 2-2 2" />
                  </svg>
                  <svg v-else class="mr-1 h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <rect x="3" y="11" width="18" height="10" rx="2" ry="2" stroke-width="2" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 11V8a5 5 0 0110 0v3" />
                  </svg>
                  {{ getPurchaseTypeLabel(product.purchase_type) }}
                </span>

                <span
                  class="inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-semibold"
                  :class="product.fulfillment_type === 'auto'
                    ? 'border-sky-500/40 bg-sky-500/12 text-sky-700 dark:text-sky-300'
                    : 'border-slate-500/40 bg-slate-500/12 text-slate-700 dark:text-slate-300'"
                >
                  <svg v-if="product.fulfillment_type === 'auto'" class="mr-1 h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 2L3 14h7l-1 8 10-12h-7l1-8z" />
                  </svg>
                  <svg v-else class="mr-1 h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.7 6.3l3 3m-9.4 9.4l-4 1 1-4 9.9-9.9a2.1 2.1 0 013 3L8.3 18.7z" />
                  </svg>
                  {{ getFulfillmentTypeLabel(product.fulfillment_type) }}
                </span>

                <span
                  class="inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-semibold"
                  :class="getStockBadgeClass(product.stock_status)"
                >
                  {{ getStockStatusLabel(product) }}
                </span>
              </div>

              <p class="line-clamp-2 text-sm text-gray-600 dark:text-gray-300">{{ getLocalizedText(product.description) }}</p>
              <div class="pt-1">
                <div class="flex flex-col">
                  <span class="text-xs text-gray-500 uppercase tracking-wider">{{ t('products.price') }}</span>
                  <span v-if="hasPromotionPrice(product)" class="text-lg font-bold text-rose-600 dark:text-rose-300 font-mono">
                    {{ formatPrice(getPromotionPriceAmount(product), product.price_currency) }}
                  </span>
                  <span v-else class="text-lg font-bold text-gray-900 dark:text-white font-mono">
                    {{ formatPrice(product.price_amount, product.price_currency) }}
                  </span>
                  <div v-if="hasPromotionPrice(product)" class="mt-0.5 flex flex-wrap items-center gap-1.5">
                    <span class="text-xs text-gray-400 line-through">{{ formatPrice(product.price_amount, product.price_currency) }}</span>
                    <span class="inline-flex items-center rounded-full border border-rose-500/30 bg-rose-500/10 px-1.5 py-0.5 text-[10px] font-semibold text-rose-700 dark:text-rose-300">
                      {{ t('products.promotionTag') }}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </article>
        </div>
        <div v-else class="rounded-2xl border border-dashed border-gray-300 py-16 text-center text-gray-500 dark:border-white/20 dark:text-gray-300">
          {{ t('home.featured.empty') }}
        </div>
      </div>
    </section>

    <section class="relative z-10 border-t border-gray-200/70 py-12 dark:border-white/10">
      <div class="container mx-auto px-4">
        <div class="mb-6 flex items-end justify-between gap-4">
          <div>
            <h2 class="text-2xl font-bold">{{ t('home.latest.title') }}</h2>
            <p class="mt-1 text-sm text-gray-600 dark:text-gray-300">{{ t('home.latest.description') }}</p>
          </div>
          <div class="flex items-center gap-3 text-sm">
            <router-link to="/blog" class="text-gray-600 hover:text-black dark:text-gray-300 dark:hover:text-white">{{ t('nav.blog') }}</router-link>
            <router-link to="/notice" class="text-gray-600 hover:text-black dark:text-gray-300 dark:hover:text-white">{{ t('nav.notice') }}</router-link>
          </div>
        </div>

        <div v-if="posts.length > 0" class="grid grid-cols-1 gap-5 md:grid-cols-3">
          <article
            v-for="post in posts"
            :key="post.id"
            class="cursor-pointer rounded-xl border border-gray-200 bg-white p-5 transition hover:shadow-md dark:border-white/10 dark:bg-white/5"
            @click="goToPost(post.slug)"
          >
            <div class="mb-2 text-xs text-gray-500 dark:text-gray-300">{{ formatDate(post.created_at) }}</div>
            <h3 class="line-clamp-2 text-base font-semibold">{{ getLocalizedText(post.title) }}</h3>
            <p class="mt-2 line-clamp-2 text-sm text-gray-600 dark:text-gray-300">{{ getLocalizedText(post.summary) }}</p>
            <div class="mt-4 text-sm font-medium text-purple-600 dark:text-purple-300">{{ t('blog.readMore') }}</div>
          </article>
        </div>
        <div v-else class="rounded-2xl border border-dashed border-gray-300 py-12 text-center text-gray-500 dark:border-white/20 dark:text-gray-300">
          {{ t('blog.empty') }}
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '../stores/app'
import { bannerAPI, postAPI, productAPI } from '../api'
import { getFirstImageUrl, getImageUrl } from '../utils/image'
import { debounceAsync } from '../utils/debounce'

const router = useRouter()
const { t } = useI18n()
const appStore = useAppStore()

const products = ref<any[]>([])
const posts = ref<any[]>([])
const banners = ref<any[]>([])
const bannerLoading = ref(true)

const currentBannerIndex = ref(0)
let heroAutoPlayTimer: ReturnType<typeof setInterval> | null = null

const getLocalizedText = (jsonData: any) => {
  if (!jsonData) return ''
  const locale = appStore.locale
  return jsonData[locale] || jsonData['zh-CN'] || jsonData['en-US'] || ''
}

const getPurchaseTypeLabel = (purchaseType: string) => {
  return purchaseType === 'guest' ? t('productPurchase.guest') : t('productPurchase.member')
}

const getFulfillmentTypeLabel = (fulfillmentType: string) => {
  return fulfillmentType === 'auto' ? t('products.fulfillmentType.auto') : t('products.fulfillmentType.manual')
}

const getStockBadgeClass = (status: string) => {
  switch (status) {
    case 'unlimited':
      return 'border-violet-500/40 bg-violet-500/12 text-violet-700 dark:text-violet-300'
    case 'low_stock':
      return 'border-orange-500/40 bg-orange-500/12 text-orange-700 dark:text-orange-300'
    case 'out_of_stock':
      return 'border-rose-500/40 bg-rose-500/12 text-rose-700 dark:text-rose-300'
    default:
      return 'border-emerald-500/40 bg-emerald-500/12 text-emerald-700 dark:text-emerald-300'
  }
}

const getStockStatusLabel = (product: any) => {
  const status = product?.stock_status || ''
  if (status === 'unlimited') return t('products.stockStatus.unlimited')
  if (status === 'out_of_stock') return t('products.stockStatus.outOfStock')
  if (status === 'low_stock') {
    const count = Number(product?.fulfillment_type === 'manual' ? product?.manual_stock_available : product?.auto_stock_available)
    if (Number.isFinite(count) && count > 0) {
      return t('products.stockStatus.lowStockCount', { count })
    }
    return t('products.stockStatus.lowStock')
  }
  return t('products.stockStatus.inStock')
}

const isSoldOut = (product: any) => Boolean(product?.is_sold_out || product?.stock_status === 'out_of_stock')

const bannerCount = computed(() => banners.value.length)

const heroBanner = computed(() => {
  if (banners.value.length === 0) return null
  if (currentBannerIndex.value >= banners.value.length) return banners.value[0]
  return banners.value[currentBannerIndex.value]
})



const goToBanner = (index: number) => {
  if (banners.value.length === 0) return
  const total = banners.value.length
  currentBannerIndex.value = ((index % total) + total) % total
}

const nextHeroBanner = () => {
  goToBanner(currentBannerIndex.value + 1)
}

const prevHeroBanner = () => {
  goToBanner(currentBannerIndex.value - 1)
}

const stopHeroAutoPlay = () => {
  if (heroAutoPlayTimer) {
    clearInterval(heroAutoPlayTimer)
    heroAutoPlayTimer = null
  }
}

const startHeroAutoPlay = () => {
  stopHeroAutoPlay()
  if (banners.value.length <= 1) return
  heroAutoPlayTimer = setInterval(() => {
    nextHeroBanner()
  }, 5000)
}

const handleNextHeroBanner = () => {
  nextHeroBanner()
  startHeroAutoPlay()
}

const handlePrevHeroBanner = () => {
  prevHeroBanner()
  startHeroAutoPlay()
}

const selectHeroBanner = (index: number) => {
  goToBanner(index)
  startHeroAutoPlay()
}

const heroImage = computed(() => {
  const banner = heroBanner.value
  if (!banner) return ''
  const isMobile = typeof window !== 'undefined' && window.innerWidth < 768
  if (isMobile && banner.mobile_image) {
    return getImageUrl(banner.mobile_image)
  }
  return getImageUrl(banner.image || banner.mobile_image || '')
})

const heroBadge = computed(() => {
  if (!heroBanner.value) return t('home.hero.badge')
  return getLocalizedText(heroBanner.value.title) || t('home.hero.badge')
})

const heroTitle = computed(() => {
  if (!heroBanner.value) return t('home.hero.title')
  return getLocalizedText(heroBanner.value.title) || t('home.hero.title')
})

const heroSubtitle = computed(() => {
  if (!heroBanner.value) return t('home.hero.subtitle')
  return getLocalizedText(heroBanner.value.subtitle) || t('home.hero.subtitle')
})

const heroLink = computed(() => {
  const banner = heroBanner.value
  if (!banner || banner.link_type === 'none') return ''
  return banner.link_value || ''
})

const hasHeroLink = computed(() => heroLink.value.trim().length > 0)

const heroPrimaryButtonText = computed(() => {
  if (!hasHeroLink.value) return t('home.hero.cta')
  const linkType = String(heroBanner.value?.link_type || '').toLowerCase()
  if (linkType === 'external') {
    return t('common.learnMore')
  }
  return t('common.viewDetails')
})

const heroOpenInNewTab = computed(() => Boolean(heroBanner.value?.open_in_new_tab))

const goToHeroLink = () => {
  if (!heroLink.value) {
    router.push('/products')
    return
  }
  const isExternal = /^https?:\/\//i.test(heroLink.value)
  if (isExternal || heroOpenInNewTab.value) {
    window.open(heroLink.value, heroOpenInNewTab.value ? '_blank' : '_self')
    return
  }
  router.push(heroLink.value)
}

const formatPrice = (amount: any, currency: any) => {
  if (amount === null || amount === undefined || amount === '') return '-'
  if (currency === null || currency === undefined || currency === '') {
    return String(amount)
  }
  return `${amount} ${currency}`
}

const parsePriceAmount = (amount: any) => {
  const numeric = Number(amount)
  if (!Number.isFinite(numeric)) return null
  return numeric
}

const getPromotionPriceAmount = (product: any) => product?.promotion_price_amount

const hasPromotionPrice = (product: any) => {
  if (!product) return false
  const original = parsePriceAmount(product.price_amount)
  const promotion = parsePriceAmount(product.promotion_price_amount)
  if (original === null || promotion === null) return false
  return promotion >= 0 && promotion < original
}

const formatDate = (dateString: string) => {
  if (!dateString) return ''
  return new Date(dateString).toLocaleDateString()
}

const goToProduct = (slug: string) => {
  router.push(`/products/${slug}`)
}

const goToPost = (slug: string) => {
  router.push(`/blog/${slug}`)
}

const loadFeaturedProducts = async () => {
  try {
    const response = await productAPI.list({ page: 1, page_size: 9 })
    products.value = response.data.data || []
  } catch (error) {
    console.error('Failed to load products:', error)
  }
}

const loadLatestPosts = async () => {
  try {
    const response = await postAPI.list({ page: 1, page_size: 3 })
    posts.value = response.data.data || []
  } catch (error) {
    console.error('Failed to load posts:', error)
  }
}

const loadHeroBanners = async () => {
  bannerLoading.value = true
  try {
    const response = await bannerAPI.list({ position: 'home_hero', limit: 5 })
    banners.value = response.data.data || []
    currentBannerIndex.value = 0
    startHeroAutoPlay()
  } catch (error) {
    banners.value = []
    currentBannerIndex.value = 0
    stopHeroAutoPlay()
    console.error('Failed to load banners:', error)
  } finally {
    bannerLoading.value = false
  }
}

const debouncedLoadFeaturedProducts = debounceAsync(loadFeaturedProducts, 250)
const debouncedLoadLatestPosts = debounceAsync(loadLatestPosts, 250)
const debouncedLoadHeroBanners = debounceAsync(loadHeroBanners, 250)

onMounted(async () => {
  await Promise.all([debouncedLoadHeroBanners(), debouncedLoadFeaturedProducts(), debouncedLoadLatestPosts()])
})

onUnmounted(() => {
  debouncedLoadFeaturedProducts.cancel()
  debouncedLoadLatestPosts.cancel()
  debouncedLoadHeroBanners.cancel()
  stopHeroAutoPlay()
})
</script>
