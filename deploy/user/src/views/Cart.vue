<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 dark:bg-[#0a0a0a] dark:text-white pt-24 pb-16">
    <div class="container mx-auto px-4">
      <div class="mb-8">
        <h1 class="mb-2 text-3xl font-black text-gray-900 dark:text-white">{{ t('cart.title') }}</h1>
        <p class="text-sm text-gray-600 dark:text-gray-400">{{ t('cart.subtitle') }}</p>
      </div>

      <div class="mb-8 rounded-2xl border border-gray-200 bg-white/80 p-4 backdrop-blur dark:border-white/10 dark:bg-[#111]/70">
        <div class="grid grid-cols-3 gap-3">
          <div
            v-for="step in flowSteps"
            :key="step.key"
            class="rounded-xl border px-3 py-2 text-center text-sm font-semibold transition-colors"
            :class="step.active
              ? 'border-gray-900 bg-gray-900 text-white dark:border-white dark:bg-white dark:text-black'
              : 'border-gray-200 bg-gray-50 text-gray-500 dark:border-white/10 dark:bg-black/20 dark:text-gray-400'"
          >
            {{ step.label }}
          </div>
        </div>
      </div>

      <div
        v-if="cartItems.length === 0"
        class="rounded-2xl border border-gray-200 bg-white p-12 text-center dark:border-white/10 dark:bg-[#111]/80"
      >
        <p class="mb-6 text-gray-500 dark:text-gray-400">{{ t('cart.empty') }}</p>
        <router-link
          to="/products"
          class="inline-flex items-center gap-2 rounded-xl bg-gray-900 px-6 py-3 font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
        >
          {{ t('cart.emptyAction') }}
        </router-link>
      </div>

      <div v-else class="grid grid-cols-1 gap-8 lg:grid-cols-3">
        <div class="space-y-4 lg:col-span-2">
          <article
            v-for="item in cartItems"
            :key="item.productId"
            class="rounded-2xl border border-gray-200 bg-white p-5 dark:border-white/10 dark:bg-[#111]/80"
          >
            <div class="flex gap-5">
              <div
                class="h-24 w-24 flex-shrink-0 overflow-hidden rounded-xl border border-gray-200 bg-gray-100 dark:border-white/10 dark:bg-white/5"
              >
                <img v-if="item.image" :src="item.image" class="h-full w-full object-cover" />
                <div v-else class="flex h-full w-full items-center justify-center text-gray-400 dark:text-gray-600">
                  <svg class="h-8 w-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                    />
                  </svg>
                </div>
              </div>

              <div class="flex-1">
                <div class="flex items-start justify-between gap-4">
                  <div>
                    <router-link
                      :to="`/products/${item.slug}`"
                      class="text-lg font-bold text-gray-900 transition-colors hover:text-purple-600 dark:text-white dark:hover:text-purple-400"
                    >
                      {{ getLocalizedText(item.title) }}
                    </router-link>
                    <p class="mt-1 text-sm text-gray-500">{{ t('cart.priceLabel') }}：{{ formatPrice(item.priceAmount, item.priceCurrency) }}</p>
                    <div class="mt-3 flex flex-wrap gap-2">
                      <span
                        class="rounded-full border px-2.5 py-1 text-xs font-semibold uppercase tracking-wider"
                        :class="item.purchaseType === 'guest'
                          ? 'border-amber-500/30 bg-amber-500/10 text-amber-700 dark:text-amber-300'
                          : 'border-emerald-500/30 bg-emerald-500/10 text-emerald-700 dark:text-emerald-300'"
                      >
                        {{ item.purchaseType === 'guest' ? t('productPurchase.guest') : t('productPurchase.member') }}
                      </span>
                      <span
                        class="rounded-full border px-2.5 py-1 text-xs font-semibold uppercase tracking-wider"
                        :class="item.fulfillmentType === 'auto'
                          ? 'border-sky-500/30 bg-sky-500/10 text-sky-700 dark:text-sky-300'
                          : 'border-slate-500/30 bg-slate-500/10 text-slate-700 dark:text-slate-300'"
                      >
                        {{ item.fulfillmentType === 'auto' ? t('products.fulfillmentType.auto') : t('products.fulfillmentType.manual') }}
                      </span>
                    </div>
                  </div>
                  <button
                    @click="cartStore.removeItem(item.productId)"
                    class="text-sm text-gray-500 transition-colors hover:text-red-500"
                  >
                    {{ t('cart.remove') }}
                  </button>
                </div>

                <div class="mt-4 flex flex-wrap items-center justify-between gap-3 border-t border-gray-100 pt-4 dark:border-white/5">
                  <div class="flex items-center gap-2">
                    <button
                      @click="updateQty(item, item.quantity - 1)"
                      :disabled="item.quantity <= 1"
                      class="h-8 w-8 rounded-lg border border-gray-200 bg-gray-100 text-gray-600 transition-colors hover:border-purple-500/40 disabled:cursor-not-allowed disabled:opacity-40 dark:border-white/10 dark:bg-white/5 dark:text-gray-300"
                    >
                      -
                    </button>
                    <span class="min-w-[32px] text-center text-sm font-mono text-gray-900 dark:text-white">{{ item.quantity }}</span>
                    <button
                      @click="updateQty(item, item.quantity + 1)"
                      :disabled="item.quantity >= 99"
                      class="h-8 w-8 rounded-lg border border-gray-200 bg-gray-100 text-gray-600 transition-colors hover:border-purple-500/40 disabled:cursor-not-allowed disabled:opacity-40 dark:border-white/10 dark:bg-white/5 dark:text-gray-300"
                    >
                      +
                    </button>
                  </div>

                  <div class="text-right">
                    <p class="text-xs uppercase tracking-wider text-gray-500">{{ t('checkout.previewTotal') }}</p>
                    <p class="text-sm font-semibold text-gray-900 dark:text-white">{{ itemSubtotal(item) }}</p>
                  </div>
                </div>
              </div>
            </div>
          </article>
        </div>

        <div class="h-fit rounded-2xl border border-gray-200 bg-white p-6 lg:sticky lg:top-24 dark:border-white/10 dark:bg-[#111]/80">
          <h2 class="mb-4 text-lg font-bold text-gray-900 dark:text-white">{{ t('cart.summaryTitle') }}</h2>
          <div class="space-y-3 text-sm text-gray-500 dark:text-gray-400">
            <div class="flex items-center justify-between">
              <span>{{ t('cart.itemsCount') }}</span>
              <span class="font-mono text-gray-900 dark:text-white">{{ totalItems }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span>{{ t('cart.totalLabel') }}</span>
              <span class="font-mono text-lg font-bold text-gray-900 dark:text-white">{{ formatPrice(totalAmount.toFixed(2), totalCurrency) }}</span>
            </div>
            <div class="rounded-lg border border-gray-100 bg-gray-50 p-3 text-xs text-gray-500 dark:border-white/10 dark:bg-black/20 dark:text-gray-400">
              {{ t('cart.disclaimer') }}
            </div>
          </div>

          <div class="mt-6 space-y-2">
            <router-link
              to="/checkout"
              class="inline-flex w-full items-center justify-center gap-2 rounded-xl bg-gray-900 px-6 py-3 font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
            >
              {{ t('cart.checkout') }}
            </router-link>
            <router-link
              to="/products"
              class="inline-flex w-full items-center justify-center gap-2 rounded-xl border border-gray-200 px-6 py-3 font-semibold text-gray-600 transition-colors hover:border-gray-300 hover:text-gray-900 dark:border-white/10 dark:text-gray-300 dark:hover:border-white/30 dark:hover:text-white"
            >
              {{ t('cart.emptyAction') }}
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { useCartStore, type CartItem } from '../stores/cart'
import { useAppStore } from '../stores/app'

const cartStore = useCartStore()
const appStore = useAppStore()
const { t } = useI18n()

const cartItems = computed(() => cartStore.items)
const totalItems = computed(() => cartStore.totalItems)
const totalAmount = computed(() => cartItems.value.reduce((sum, item) => {
  const amount = Number(item.priceAmount || 0)
  const qty = Number(item.quantity || 0)
  if (Number.isNaN(amount) || Number.isNaN(qty)) return sum
  return sum + amount * qty
}, 0))
const totalCurrency = computed(() => {
  const currencies = cartItems.value.map(item => item.priceCurrency).filter(Boolean)
  const unique = Array.from(new Set(currencies))
  return unique.length === 1 ? unique[0] : ''
})

const flowSteps = computed(() => ([
  { key: 'cart', label: t('cart.title'), active: true },
  { key: 'checkout', label: t('checkout.title'), active: false },
  { key: 'payment', label: t('payment.title'), active: false },
]))

const getLocalizedText = (jsonData: any) => {
  if (!jsonData) return ''
  const locale = appStore.locale
  return jsonData[locale] || jsonData['zh-CN'] || jsonData['en-US'] || ''
}

const formatPrice = (amount: any, currency: any) => {
  if (amount === null || amount === undefined || amount === '') return '-'
  if (currency === null || currency === undefined || currency === '') {
    return String(amount)
  }
  return `${amount} ${currency}`
}

const itemSubtotal = (item: CartItem) => {
  const amount = Number(item.priceAmount || 0)
  const qty = Number(item.quantity || 0)
  if (Number.isNaN(amount) || Number.isNaN(qty)) {
    return formatPrice('-', item.priceCurrency)
  }
  return formatPrice((amount * qty).toFixed(2), item.priceCurrency)
}

const updateQty = (item: CartItem, qty: number) => {
  cartStore.updateQuantity(item.productId, qty)
}
</script>
