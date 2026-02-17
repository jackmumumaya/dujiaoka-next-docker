<template>
  <div
    class="product-detail-page min-h-screen bg-gray-50 dark:bg-[#0a0a0a] text-gray-900 dark:text-white pt-24 pb-16 relative overflow-hidden">
    <!-- Background Decor -->
    <div class="fixed inset-0 z-0 pointer-events-none">
      <div class="absolute inset-0 bg-[url('/noise.svg')] opacity-20 brightness-100 contrast-150 mix-blend-overlay">
      </div>
      <div class="absolute top-0 left-0 w-[50%] h-[50%] bg-purple-900/20 blur-[150px] rounded-full"></div>
      <div class="absolute bottom-0 right-0 w-[50%] h-[50%] bg-blue-900/20 blur-[150px] rounded-full"></div>
    </div>

    <div class="container mx-auto px-4 relative z-10">
      <!-- Loading State -->
      <div v-if="loading" class="animate-pulse space-y-8">
        <div class="h-8 bg-gray-200 dark:bg-gray-800 rounded w-1/3"></div>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
          <div class="h-[500px] bg-gray-200 dark:bg-gray-800 rounded-2xl"></div>
          <div class="space-y-6">
            <div class="h-10 bg-gray-200 dark:bg-gray-800 rounded w-3/4"></div>
            <div class="h-6 bg-gray-200 dark:bg-gray-800 rounded w-1/2"></div>
            <div class="h-32 bg-gray-200 dark:bg-gray-800 rounded"></div>
          </div>
        </div>
      </div>

      <!-- Product Content -->
      <div v-else-if="product">
        <!-- Breadcrumb -->
        <nav class="mb-8 flex items-center space-x-2 text-sm text-gray-500 font-medium">
          <router-link to="/" class="hover:text-gray-900 dark:hover:text-white transition-colors">{{ t('nav.home')
          }}</router-link>
          <span>/</span>
          <router-link to="/products" class="hover:text-gray-900 dark:hover:text-white transition-colors">{{
            t('nav.products') }}</router-link>
          <span>/</span>
          <span class="text-gray-900 dark:text-white truncate max-w-[200px]">{{ getLocalizedText(product.title)
          }}</span>
        </nav>

        <!-- Main Info Card -->
        <div
          class="bg-white dark:bg-[#111]/80 backdrop-blur-xl border border-gray-200 dark:border-white/5 rounded-3xl overflow-hidden mb-8 shadow-2xl">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-0">
            <!-- Product Images (Left) -->
            <div class="p-8 bg-gray-50 dark:bg-black/20 border-r border-gray-100 dark:border-white/5">
              <div class="mb-6 relative group">
                <div
                  class="absolute inset-0 bg-purple-500/10 blur-2xl rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                </div>
                <img v-if="currentImage" :src="currentImage" :alt="getLocalizedText(product.title)"
                  class="w-full h-[400px] lg:h-[500px] object-cover rounded-xl border border-gray-200 dark:border-white/10 relative z-10 shadow-lg" />
                <div v-else
                  class="w-full h-[400px] lg:h-[500px] bg-gray-200 dark:bg-white/5 rounded-xl border border-gray-200 dark:border-white/10 flex items-center justify-center relative z-10">
                  <svg class="w-24 h-24 text-gray-700" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd"
                      d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z"
                      clip-rule="evenodd" />
                  </svg>
                </div>
              </div>

              <!-- Thumbnail Gallery -->
              <div v-if="images.length > 1" class="grid grid-cols-5 gap-3">
                <div v-for="(image, index) in images" :key="index" @click="currentImage = image"
                  class="cursor-pointer rounded-lg overflow-hidden border-2 transition-all duration-300 aspect-w-1 aspect-h-1"
                  :class="currentImage === image ? 'border-purple-500 shadow-[0_0_10px_rgba(168,85,247,0.5)]' : 'border-transparent opacity-60 hover:opacity-100 hover:scale-105'">
                  <img :src="image" :alt="`Image ${index + 1}`" class="w-full h-full object-cover" />
                </div>
              </div>
            </div>

            <!-- Product Info (Right) -->
            <div class="p-8 lg:p-12 flex flex-col justify-center">
              <div class="mb-6">
                <div v-if="categoryName" class="mb-3 text-xs uppercase tracking-wider text-gray-500">
                  {{ t('productDetail.categoryLabel') }} · {{ categoryName }}
                </div>

                <div v-if="product.tags && product.tags.length > 0" class="mb-4 flex flex-wrap gap-2">
                  <span
                    v-for="(tag, index) in product.tags"
                    :key="index"
                    class="inline-flex items-center rounded-full border border-gray-200 bg-gray-100 px-3 py-1 text-xs font-semibold text-gray-700 dark:border-white/15 dark:bg-white/10 dark:text-gray-200"
                  >
                    {{ tag }}
                  </span>
                </div>

                <h1 class="mb-4 text-3xl font-black leading-tight text-gray-900 dark:text-white md:text-5xl">
                  {{ getLocalizedText(product.title) }}
                </h1>

                <div class="mb-6 flex flex-wrap items-center gap-2">
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

                <div class="mb-8 border-b border-gray-100 pb-8 dark:border-white/5">
                  <div class="mb-3 flex flex-wrap items-center gap-2">
                    <span class="text-sm text-gray-500">{{ t('products.price') }}</span>
                    <span v-if="hasPromotionPrice(product)" class="inline-flex items-center rounded-full border border-rose-500/30 bg-rose-500/10 px-2.5 py-1 text-[11px] font-semibold text-rose-700 dark:text-rose-300">
                      {{ t('products.promotionTag') }}
                    </span>
                  </div>
                  <div v-if="hasPromotionPrice(product)" class="space-y-2">
                    <div class="flex flex-wrap items-end gap-4">
                      <span class="bg-gradient-to-r from-rose-600 to-orange-500 bg-clip-text text-5xl font-mono font-bold text-transparent dark:from-rose-400 dark:to-orange-300">
                        {{ formatPrice(getPromotionPriceAmount(product), product.price_currency) }}
                      </span>
                      <span class="text-base font-medium text-gray-400 line-through">
                        {{ formatPrice(product.price_amount, product.price_currency) }}
                      </span>
                    </div>
                    <p class="text-sm font-medium text-rose-500 dark:text-rose-300">
                      {{ t('products.saveAmount') }} {{ formatPrice(getPromotionSaveAmount(product), product.price_currency) }}
                    </p>
                  </div>
                  <div v-else class="flex items-end gap-4">
                    <span
                      class="bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-5xl font-mono font-bold text-transparent dark:from-purple-400 dark:to-pink-400">
                      {{ formatPrice(product.price_amount, product.price_currency) }}
                    </span>
                  </div>
                </div>

                <div class="mb-8">
                  <h2 class="mb-3 text-sm font-bold uppercase tracking-widest text-gray-500 dark:text-gray-400">
                    {{ t('productDetail.description') }}
                  </h2>
                  <p class="text-lg leading-relaxed text-gray-600 dark:text-gray-300">
                    {{ getLocalizedText(product.description) }}
                  </p>
                </div>
              </div>

              <!-- Purchase Actions -->
              <div class="mt-auto space-y-6">
                <p v-if="cannotPurchaseReason" class="rounded-xl border border-rose-500/30 bg-rose-500/10 px-4 py-3 text-sm font-semibold text-rose-700 dark:text-rose-300">
                  {{ cannotPurchaseReason }}
                </p>

                <div class="space-y-3">
                  <button v-if="requiresLogin" @click="goLogin"
                    class="w-full px-6 py-4 bg-gray-900 text-white dark:bg-white dark:text-black font-bold rounded-xl hover:bg-gray-800 dark:hover:bg-gray-200 transition-colors">
                    {{ t('productDetail.loginToBuy') }}
                  </button>
                  <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <button @click="addToCart" :disabled="!canPurchase"
                      class="px-6 py-4 bg-white dark:bg-white/10 border border-gray-200 dark:border-white/10 text-gray-900 dark:text-white font-bold rounded-xl hover:border-purple-500/40 hover:bg-gray-50 dark:hover:bg-white/5 transition-colors disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:border-gray-200 disabled:hover:bg-white dark:disabled:hover:border-white/10 dark:disabled:hover:bg-white/10">
                      {{ t('productDetail.addToCart') }}
                    </button>
                    <button @click="buyNow" :disabled="!canPurchase"
                      class="px-6 py-4 bg-gray-900 text-white dark:bg-white dark:text-black font-bold rounded-xl hover:bg-gray-800 dark:hover:bg-gray-200 transition-colors disabled:cursor-not-allowed disabled:opacity-50 disabled:hover:bg-gray-900 dark:disabled:hover:bg-white">
                      {{ t('productDetail.buyNow') }}
                    </button>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>

        <!-- Details Content Card -->
        <div v-if="product.content"
          class="bg-white dark:bg-[#111]/80 backdrop-blur-xl border border-gray-200 dark:border-white/5 rounded-3xl overflow-hidden mb-12 p-8 lg:p-12 relative">
          <!-- Glow Effect -->
          <div
            class="absolute top-0 right-0 w-[300px] h-[300px] bg-purple-900/10 blur-[100px] rounded-full pointer-events-none">
          </div>

          <h2
            class="text-2xl font-bold mb-8 text-gray-900 dark:text-white flex items-center gap-3 border-b border-gray-100 dark:border-white/5 pb-6">
            <span class="w-1.5 h-8 bg-gradient-to-b from-purple-500 to-blue-500 rounded-full"></span>
            {{ t('productDetail.details') }}
          </h2>
          <div v-html="processHtmlForDisplay(getLocalizedText(product.content))"
            class="prose prose-gray dark:prose-invert prose-lg max-w-none prose-headings:text-gray-900 dark:prose-headings:text-white prose-a:text-purple-600 dark:prose-a:text-purple-400 hover:prose-a:text-purple-500 dark:hover:prose-a:text-purple-300 prose-strong:text-gray-900 dark:prose-strong:text-white">
          </div>
        </div>

        <!-- Back Button -->
        <div class="mb-12 text-center">
          <router-link to="/products"
            class="inline-flex items-center space-x-2 text-gray-500 hover:text-gray-900 dark:text-gray-400 dark:hover:text-white transition-colors border-b border-transparent hover:border-gray-900 dark:hover:border-white pb-1">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            <span>{{ t('productDetail.backToProducts') }}</span>
          </router-link>
        </div>
      </div>

      <!-- Error State -->
      <div v-else
        class="text-center py-24 bg-white dark:bg-[#111]/50 rounded-3xl border border-gray-200 dark:border-white/5 backdrop-blur-sm">
        <svg class="w-20 h-20 mx-auto text-gray-400 dark:text-gray-600 mb-6" fill="none" stroke="currentColor"
          viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
            d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p class="text-gray-500 dark:text-gray-400 text-xl mb-8">
          {{ t('productDetail.notFound') }}
        </p>
        <router-link to="/products"
          class="inline-block bg-gray-900 text-white dark:bg-white dark:text-black px-8 py-3 rounded-full font-bold hover:scale-105 transition-transform">
          {{ t('productDetail.backToProducts') }}
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '../stores/app'
import { productAPI } from '../api'
import { getImageUrl } from '../utils/image'
import { processHtmlForDisplay } from '../utils/content'
import { useCartStore } from '../stores/cart'
import { useUserAuthStore } from '../stores/userAuth'
import { debounceAsync } from '../utils/debounce'

const route = useRoute()
const router = useRouter()
const { t } = useI18n()
const appStore = useAppStore()
const cartStore = useCartStore()
const userAuthStore = useUserAuthStore()

const loading = ref(true)
const product = ref<any>(null)
const currentImage = ref<string>('')

const purchaseType = computed(() => product.value?.purchase_type || 'member')
const requiresLogin = computed(() => purchaseType.value === 'member' && !userAuthStore.isAuthenticated)
const canPurchase = computed(() => {
  if (!product.value) return false
  if (product.value.is_sold_out) return false
  return product.value.stock_status !== 'out_of_stock'
})
const cannotPurchaseReason = computed(() => {
  if (!product.value) return ''
  if (requiresLogin.value) return ''
  if (canPurchase.value) return ''
  return t('productDetail.stockUnavailable')
})
const categoryName = computed(() => {
  const category = product.value?.category?.name
  return category ? getLocalizedText(category) : ''
})

const images = computed(() => {
  if (!product.value?.images) return []
  // 处理不同的数据格式
  let imageArray: string[] = []
  if (Array.isArray(product.value.images)) {
    imageArray = product.value.images
  } else if (product.value.images.images && Array.isArray(product.value.images.images)) {
    imageArray = product.value.images.images
  }
  // 将所有图片路径转换为完整 URL
  return imageArray.map(img => getImageUrl(img))
})

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

const getStockStatusLabel = (payload: any) => {
  const status = payload?.stock_status || ''
  if (status === 'unlimited') return t('products.stockStatus.unlimited')
  if (status === 'out_of_stock') return t('products.stockStatus.outOfStock')
  if (status === 'low_stock') {
    const count = Number(payload?.fulfillment_type === 'manual' ? payload?.manual_stock_available : payload?.auto_stock_available)
    if (Number.isFinite(count) && count > 0) {
      return t('products.stockStatus.lowStockCount', { count })
    }
    return t('products.stockStatus.lowStock')
  }
  return t('products.stockStatus.inStock')
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

const getPromotionPriceAmount = (payload: any) => payload?.promotion_price_amount

const hasPromotionPrice = (payload: any) => {
  if (!payload) return false
  const original = parsePriceAmount(payload.price_amount)
  const promotion = parsePriceAmount(payload.promotion_price_amount)
  if (original === null || promotion === null) return false
  return promotion >= 0 && promotion < original
}

const getPromotionSaveAmount = (payload: any) => {
  const original = parsePriceAmount(payload?.price_amount)
  const promotion = parsePriceAmount(payload?.promotion_price_amount)
  if (original === null || promotion === null || promotion >= original) {
    return '0.00'
  }
  return (original - promotion).toFixed(2)
}

const addToCart = () => {
  if (!product.value) return
  if (!canPurchase.value) return
  if (requiresLogin.value) {
    router.push(`/auth/login?redirect=${encodeURIComponent(route.fullPath)}`)
    return
  }
  cartStore.addItem({
    productId: product.value.id,
    slug: product.value.slug,
    title: product.value.title,
    priceAmount: product.value.price_amount,
    priceCurrency: product.value.price_currency,
    image: images.value[0],
    purchaseType: product.value.purchase_type,
    fulfillmentType: product.value.fulfillment_type,
    manualFormSchema: product.value.manual_form_schema || {},
    quantity: 1,
  })
}

const buyNow = () => {
  if (!canPurchase.value) return
  addToCart()
  router.push('/checkout')
}

const goLogin = () => {
  router.push(`/auth/login?redirect=${encodeURIComponent(route.fullPath)}`)
}

const loadProduct = async () => {
  loading.value = true
  try {
    const slug = route.params.slug as string
    const response = await productAPI.detail(slug)
    product.value = response.data.data || null
    if (images.value.length > 0) {
      currentImage.value = images.value[0] || ''
    }
  } catch (error) {
    console.error('Failed to load product:', error)
    product.value = null
  } finally {
    loading.value = false
  }
}

const debouncedLoadProduct = debounceAsync(loadProduct, 300)

onMounted(() => {
  debouncedLoadProduct()
})

onUnmounted(() => {
  debouncedLoadProduct.cancel()
})
</script>
