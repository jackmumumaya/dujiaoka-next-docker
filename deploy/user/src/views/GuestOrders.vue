<template>
  <div class="min-h-screen bg-gray-50 dark:bg-[#0a0a0a] text-gray-900 dark:text-white pt-24 pb-16">
    <div class="container mx-auto px-4">
      <div class="mb-8">
        <h1 class="text-3xl font-black text-gray-900 dark:text-white mb-2">{{ t('guestOrders.title') }}</h1>
        <p class="text-gray-500 dark:text-gray-400 text-sm">{{ t('guestOrders.subtitle') }}</p>
      </div>

      <div class="bg-white dark:bg-[#111]/80 border border-gray-200 dark:border-white/10 rounded-2xl p-6 mb-8">
        <div v-if="hasSavedAuth"
          class="mb-4 flex flex-col md:flex-row md:items-center md:justify-between gap-3 text-xs text-gray-500 dark:text-gray-400 bg-gray-50 dark:bg-black/30 border border-gray-200 dark:border-white/10 rounded-xl px-4 py-3">
          <span>{{ t('guestOrders.savedHint', { email: savedAuth.email || '-' }) }}</span>
          <button type="button" @click="clearSaved"
            class="text-gray-500 hover:text-gray-900 dark:text-white/80 dark:hover:text-white text-xs underline decoration-gray-300 dark:decoration-white/20">
            {{ t('guestOrders.clearSaved') }}
          </button>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
          <input v-model="email" type="email"
            class="bg-gray-50 dark:bg-black/40 border border-gray-200 dark:border-white/10 rounded-xl px-4 py-3 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-600 focus:outline-none focus:border-purple-500 transition-colors"
            :placeholder="t('guestOrders.emailPlaceholder')" />
          <input v-model="orderPassword" type="password"
            class="bg-gray-50 dark:bg-black/40 border border-gray-200 dark:border-white/10 rounded-xl px-4 py-3 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-600 focus:outline-none focus:border-purple-500 transition-colors"
            :placeholder="t('guestOrders.passwordPlaceholder')" />
          <input v-model="orderNo" type="text"
            class="bg-gray-50 dark:bg-black/40 border border-gray-200 dark:border-white/10 rounded-xl px-4 py-3 text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-600 focus:outline-none focus:border-purple-500 transition-colors"
            :placeholder="t('guestOrders.orderNoPlaceholder')" />
          <button @click="handleSearch" :disabled="loading"
            class="bg-gray-900 text-white dark:bg-white dark:text-black rounded-xl font-bold px-6 py-3 hover:bg-gray-800 dark:hover:bg-gray-200 transition-colors disabled:opacity-50">
            {{ loading ? t('guestOrders.searching') : t('guestOrders.search') }}
          </button>
        </div>
        <p class="text-xs text-gray-500 mt-3">{{ t('guestOrders.tip') }}</p>
        <div v-if="error" class="text-red-400 text-sm mt-4 bg-red-500/10 border border-red-500/20 rounded-lg p-3">
          {{ error }}
        </div>
      </div>

      <div v-if="orders.length === 0 && !loading"
        class="bg-white dark:bg-[#111]/80 border border-gray-200 dark:border-white/10 rounded-2xl p-12 text-center">
        <p class="text-gray-500 dark:text-gray-400">{{ emptyMessage }}</p>
      </div>

      <div v-else class="space-y-4">
        <div v-for="order in orders" :key="order.order_no || order.id"
          class="bg-white dark:bg-[#111]/80 border border-gray-200 dark:border-white/10 rounded-2xl p-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <div>
            <div class="text-xs uppercase tracking-wider text-gray-500">{{ t('orders.orderNo') }}：{{ order.order_no }}</div>
            <div class="text-lg font-bold text-gray-900 dark:text-white mt-1">{{ formatMoney(order.total_amount,
              order.currency) }}</div>
            <div v-if="hasDiscount(order)" class="text-xs text-gray-500 mt-1">
              <span v-if="hasDiscountAmount(order.discount_amount)">
                {{ t('orderDetail.couponDiscountLabel') }}：{{ formatMoney(order.discount_amount, order.currency) }}
              </span>
              <span v-if="hasDiscountAmount(order.promotion_discount_amount)" class="ml-2">
                {{ t('orderDetail.promotionDiscountLabel') }}：{{ formatMoney(order.promotion_discount_amount,
                  order.currency) }}
              </span>
            </div>
            <div class="text-xs text-gray-500 mt-1">{{ formatDate(order.created_at) }}</div>
          </div>
          <div class="flex items-center gap-3">
            <span class="px-3 py-1 rounded-full text-xs font-medium border" :class="statusClass(order.status)">
              {{ statusLabel(order.status) }}
            </span>
            <router-link :to="`/guest/orders/${order.order_no}`"
              class="px-4 py-2 rounded-lg bg-gray-50 dark:bg-white/5 border border-gray-200 dark:border-white/10 hover:border-purple-500/40 text-sm text-gray-600 dark:text-gray-300">
              {{ t('guestOrders.viewDetails') }}
            </router-link>
            <router-link v-if="order.status === 'pending_payment'" :to="`/pay?guest=1&order_no=${order.order_no}`"
              class="px-4 py-2 rounded-lg bg-gray-900 text-white dark:bg-white dark:text-black font-bold text-sm hover:bg-gray-800 dark:hover:bg-gray-200">
              {{ t('guestOrders.payNow') }}
            </router-link>
          </div>
        </div>
      </div>

      <div v-if="pagination.total_page > 1" class="flex items-center justify-center gap-4 mt-10">
        <button @click="changePage(pagination.page - 1)" :disabled="pagination.page <= 1"
          class="px-4 py-2 rounded-lg bg-gray-50 dark:bg-white/5 border border-gray-200 dark:border-white/10 text-sm text-gray-600 dark:text-gray-300 disabled:opacity-40">
          {{ t('guestOrders.prevPage') }}
        </button>
        <span class="text-sm text-gray-500">{{ t('guestOrders.pageInfo', {
          page: pagination.page, total:
            pagination.total_page
        }) }}</span>
        <button @click="changePage(pagination.page + 1)" :disabled="pagination.page >= pagination.total_page"
          class="px-4 py-2 rounded-lg bg-gray-50 dark:bg-white/5 border border-gray-200 dark:border-white/10 text-sm text-gray-600 dark:text-gray-300 disabled:opacity-40">
          {{ t('guestOrders.nextPage') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { guestOrderAPI } from '../api'
import { useI18n } from 'vue-i18n'
import { orderStatusClass, orderStatusLabel } from '../utils/status'
import { debounceAsync } from '../utils/debounce'

const savedAuth = ref<{ email: string; order_password: string }>({ email: '', order_password: '' })
const email = ref('')
const orderPassword = ref('')
const orderNo = ref('')
const loading = ref(false)
const error = ref('')
const orders = ref<any[]>([])
const pagination = ref({
  page: 1,
  page_size: 20,
  total: 0,
  total_page: 1,
})
const { t } = useI18n()

const loadSavedAuth = () => {
  const saved = localStorage.getItem('guest_order_auth')
  const parsed = saved ? JSON.parse(saved) : {}
  savedAuth.value = {
    email: parsed.email || '',
    order_password: parsed.order_password || '',
  }
  email.value = savedAuth.value.email
  orderPassword.value = savedAuth.value.order_password
}

const hasSavedAuth = computed(() => Boolean(savedAuth.value.email || savedAuth.value.order_password))

const persistAuth = () => {
  const payload = {
    email: email.value,
    order_password: orderPassword.value,
  }
  localStorage.setItem('guest_order_auth', JSON.stringify(payload))
  savedAuth.value = payload
}

const clearSaved = () => {
  localStorage.removeItem('guest_order_auth')
  savedAuth.value = { email: '', order_password: '' }
  email.value = ''
  orderPassword.value = ''
  orderNo.value = ''
  orders.value = []
  pagination.value = {
    page: 1,
    page_size: 20,
    total: 0,
    total_page: 1,
  }
  error.value = ''
}

const handleSearch = async () => {
  error.value = ''
  if (!email.value || !orderPassword.value) {
    error.value = t('guestOrders.errors.missing')
    return
  }
  persistAuth()
  await debouncedLoadOrders(1)
}

const loadOrders = async (page: number) => {
  loading.value = true
  try {
    const response = await guestOrderAPI.list({
      email: email.value,
      order_password: orderPassword.value,
      order_no: orderNo.value || undefined,
      page,
      page_size: pagination.value.page_size,
    })
    orders.value = response.data.data || []
    pagination.value = response.data.pagination || pagination.value
    if (orderNo.value && orders.value.length === 0) {
      error.value = t('guestOrders.errors.notFound')
    }
  } catch (err: any) {
    orders.value = []
    error.value = err.message || t('guestOrders.errors.searchFailed')
  } finally {
    loading.value = false
  }
}

const debouncedLoadOrders = debounceAsync(loadOrders, 300)

const emptyMessage = computed(() => {
  if (orderNo.value) {
    return t('guestOrders.emptyOrderNo')
  }
  return t('guestOrders.empty')
})

const changePage = (page: number) => {
  if (page < 1 || page > pagination.value.total_page) return
  debouncedLoadOrders(page)
}

const statusLabel = (status: string) => orderStatusLabel(t, status)

const formatMoney = (amount?: string, currency?: string) => {
  if (amount === null || amount === undefined || amount === '') return '-'
  if (currency === null || currency === undefined || currency === '') {
    return String(amount)
  }
  return `${amount} ${currency}`
}

const hasDiscountAmount = (amount?: string) => {
  if (amount === null || amount === undefined || amount === '') return false
  const value = Number(amount)
  return !Number.isNaN(value) && value > 0
}

const hasDiscount = (order: any) => {
  if (!order) return false
  return hasDiscountAmount(order.discount_amount) || hasDiscountAmount(order.promotion_discount_amount)
}

const statusClass = (status: string) => orderStatusClass(status)

const formatDate = (raw?: string) => {
  if (!raw) return ''
  const date = new Date(raw)
  if (Number.isNaN(date.getTime())) return raw
  return date.toLocaleString()
}

onMounted(() => {
  loadSavedAuth()
  if (hasSavedAuth.value) {
    debouncedLoadOrders(1)
  }
})

onUnmounted(() => {
  debouncedLoadOrders.cancel()
})
</script>
