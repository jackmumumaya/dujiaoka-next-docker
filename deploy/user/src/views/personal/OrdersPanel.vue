<template>
  <div class="space-y-4">
    <div class="rounded-2xl border border-gray-200/80 bg-white/95 p-6 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <h2 class="text-xl font-bold text-gray-900 dark:text-white">{{ t('orders.title') }}</h2>
          <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">{{ t('orders.subtitle') }}</p>
        </div>

        <div class="flex flex-wrap items-center gap-2">
          <span class="rounded-full border border-gray-200 bg-gray-50 px-3 py-1 text-xs font-semibold text-gray-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300">
            {{ t('orders.pageInfo', { page: pagination.page, total: pagination.total_page }) }}
          </span>
          <router-link
            to="/products"
            class="inline-flex items-center rounded-full border border-gray-200 px-3 py-1 text-xs font-semibold text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
          >
            {{ t('orders.continueShopping') }}
          </router-link>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-2 gap-3 lg:grid-cols-4">
      <div class="rounded-2xl border border-gray-200/80 bg-white p-4 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
        <div class="text-xs text-gray-500 dark:text-gray-400">{{ t('orders.stats.totalMatched') }}</div>
        <div class="mt-2 text-xl font-bold text-gray-900 dark:text-white">{{ pagination.total }}</div>
      </div>
      <div class="rounded-2xl border border-gray-200/80 bg-white p-4 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
        <div class="text-xs text-gray-500 dark:text-gray-400">{{ t('orders.stats.currentPage') }}</div>
        <div class="mt-2 text-xl font-bold text-gray-900 dark:text-white">{{ orders.length }}</div>
      </div>
      <div class="rounded-2xl border border-amber-200/70 bg-amber-50/70 p-4 shadow-sm dark:border-amber-500/30 dark:bg-amber-500/10">
        <div class="text-xs text-amber-700 dark:text-amber-200">{{ t('orders.stats.pendingPayment') }}</div>
        <div class="mt-2 text-xl font-bold text-amber-700 dark:text-amber-200">{{ pendingPaymentCount }}</div>
      </div>
      <div class="rounded-2xl border border-emerald-200/70 bg-emerald-50/70 p-4 shadow-sm dark:border-emerald-500/30 dark:bg-emerald-500/10">
        <div class="text-xs text-emerald-700 dark:text-emerald-200">{{ t('orders.stats.finished') }}</div>
        <div class="mt-2 text-xl font-bold text-emerald-700 dark:text-emerald-200">{{ finishedCount }}</div>
      </div>
    </div>

    <div class="rounded-2xl border border-gray-200/80 bg-white/95 p-4 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
      <div class="flex flex-col gap-3 lg:flex-row lg:items-end">
        <div class="w-full lg:max-w-sm">
          <label class="mb-1 block text-xs font-semibold text-gray-500 dark:text-gray-400">{{ t('orders.filters.keyword') }}</label>
          <input
            v-model.trim="filters.orderNo"
            type="text"
            :placeholder="t('orders.filters.orderNoPlaceholder')"
            class="h-11 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 text-sm text-gray-900 transition-colors placeholder:text-gray-400 focus:border-indigo-300 focus:bg-white focus:outline-none dark:border-white/10 dark:bg-black/30 dark:text-white dark:placeholder:text-gray-500 dark:focus:border-indigo-500/40"
            @input="handleOrderNoInput"
            @keyup.enter="applyFilters"
          />
        </div>

        <div class="w-full lg:w-56">
          <label class="mb-1 block text-xs font-semibold text-gray-500 dark:text-gray-400">{{ t('orders.filters.status') }}</label>
          <select
            v-model="filters.status"
            class="h-11 w-full rounded-xl border border-gray-200 bg-gray-50 px-4 text-sm text-gray-900 transition-colors focus:border-indigo-300 focus:bg-white focus:outline-none dark:border-white/10 dark:bg-black/30 dark:text-white dark:focus:border-indigo-500/40"
            @change="handleStatusChange"
          >
            <option v-for="item in statusOptions" :key="item.value || 'all'" :value="item.value">
              {{ item.label }}
            </option>
          </select>
        </div>

        <div class="flex w-full flex-wrap items-center gap-2 lg:w-auto">
          <button
            type="button"
            class="inline-flex h-11 items-center rounded-xl bg-gray-900 px-4 text-sm font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
            @click="applyFilters"
          >
            {{ t('orders.filters.search') }}
          </button>
          <button
            type="button"
            class="inline-flex h-11 items-center rounded-xl border border-gray-200 bg-gray-50 px-4 text-sm font-semibold text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
            @click="resetFilters"
          >
            {{ t('orders.filters.reset') }}
          </button>
          <button
            type="button"
            class="inline-flex h-11 items-center rounded-xl border border-gray-200 bg-gray-50 px-4 text-sm font-semibold text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
            @click="refreshCurrentPage"
          >
            {{ t('orders.filters.refresh') }}
          </button>
        </div>
      </div>

      <div v-if="hasActiveFilters" class="mt-3 text-xs text-gray-500 dark:text-gray-400">
        {{ t('orders.filters.current', { orderNo: filters.orderNo || t('orders.filters.any'), status: currentStatusLabel }) }}
      </div>
    </div>

    <div v-if="loading" class="space-y-4">
      <div
        v-for="i in 3"
        :key="i"
        class="h-24 animate-pulse rounded-2xl border border-gray-200 bg-gray-100 dark:border-white/10 dark:bg-white/5"
      ></div>
    </div>

    <div v-else-if="orders.length === 0" class="rounded-2xl border border-gray-200/80 bg-white/95 p-12 text-center shadow-sm dark:border-white/10 dark:bg-[#111]/85">
      <p class="mb-6 text-gray-500 dark:text-gray-400">{{ hasActiveFilters ? t('orders.emptyFiltered') : t('orders.empty') }}</p>
      <router-link
        to="/products"
        class="inline-flex items-center gap-2 rounded-xl bg-gray-900 px-6 py-3 font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
      >
        {{ t('orders.emptyAction') }}
      </router-link>
    </div>

    <div v-else class="space-y-4">
      <div
        v-for="order in orders"
        :key="order.order_no || order.id"
        class="rounded-2xl border border-gray-200/80 bg-white/95 p-6 shadow-sm transition-all hover:-translate-y-0.5 hover:border-indigo-200 hover:shadow-[0_18px_40px_-30px_rgba(79,70,229,0.85)] dark:border-white/10 dark:bg-[#111]/85 dark:hover:border-indigo-500/35"
      >
        <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div>
            <div class="text-xs uppercase tracking-[0.16em] text-gray-500">{{ t('orders.orderNo') }}：{{ order.order_no }}</div>
            <div class="mt-2 text-lg font-bold text-gray-900 dark:text-white">{{ formatMoney(order.total_amount, order.currency) }}</div>
            <div v-if="hasDiscount(order)" class="mt-2 flex flex-wrap gap-2 text-xs text-gray-500">
              <span v-if="hasDiscountAmount(order.discount_amount)" class="rounded-full border border-emerald-200 bg-emerald-50 px-2.5 py-1 text-emerald-700 dark:border-emerald-500/35 dark:bg-emerald-500/12 dark:text-emerald-200">
                {{ t('orderDetail.couponDiscountLabel') }}：{{ formatMoney(order.discount_amount, order.currency) }}
              </span>
              <span v-if="hasDiscountAmount(order.promotion_discount_amount)" class="rounded-full border border-rose-200 bg-rose-50 px-2.5 py-1 text-rose-700 dark:border-rose-500/35 dark:bg-rose-500/12 dark:text-rose-200">
                {{ t('orderDetail.promotionDiscountLabel') }}：{{ formatMoney(order.promotion_discount_amount, order.currency) }}
              </span>
            </div>
            <div class="mt-2 text-xs text-gray-500">{{ formatDate(order.created_at) }}</div>
          </div>

          <div class="flex flex-wrap items-center gap-3">
            <span class="rounded-full border px-3 py-1 text-xs font-medium" :class="statusClass(order.status)">
              {{ statusLabel(order.status) }}
            </span>
            <router-link
              :to="`/orders/${order.order_no}`"
              class="rounded-lg border border-gray-200 bg-gray-50 px-4 py-2 text-sm font-medium text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
            >
              {{ t('orders.viewDetails') }}
            </router-link>
            <router-link
              v-if="order.status === 'pending_payment'"
              :to="`/pay?order_no=${order.order_no}`"
              class="rounded-lg bg-gray-900 px-4 py-2 text-sm font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
            >
              {{ t('orders.payNow') }}
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <div v-if="pagination.total_page > 1" class="mt-8 flex flex-wrap items-center justify-center gap-3">
      <button
        :disabled="pagination.page <= 1"
        class="rounded-lg border border-gray-200 bg-gray-50 px-4 py-2 text-sm font-medium text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 disabled:cursor-not-allowed disabled:opacity-40 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
        @click="changePage(pagination.page - 1)"
      >
        {{ t('orders.prevPage') }}
      </button>
      <span class="rounded-full border border-gray-200 bg-white px-4 py-2 text-sm text-gray-600 dark:border-white/10 dark:bg-[#0f0f0f] dark:text-gray-300">
        {{ t('orders.pageInfo', { page: pagination.page, total: pagination.total_page }) }}
      </span>
      <button
        :disabled="pagination.page >= pagination.total_page"
        class="rounded-lg border border-gray-200 bg-gray-50 px-4 py-2 text-sm font-medium text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 disabled:cursor-not-allowed disabled:opacity-40 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
        @click="changePage(pagination.page + 1)"
      >
        {{ t('orders.nextPage') }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { userOrderAPI } from '../../api'
import { orderStatusClass, orderStatusLabel } from '../../utils/status'
import { debounceAsync } from '../../utils/debounce'

const { t } = useI18n()

const loading = ref(true)
const orders = ref<any[]>([])
const pagination = ref({
  page: 1,
  page_size: 20,
  total: 0,
  total_page: 1,
})

const filters = reactive({
  orderNo: '',
  status: '',
})

const statusOptions = computed(() => [
  { value: '', label: t('orders.filters.statusAll') },
  { value: 'pending_payment', label: t('order.status.pending_payment') },
  { value: 'paid', label: t('order.status.paid') },
  { value: 'fulfilling', label: t('order.status.fulfilling') },
  { value: 'partially_delivered', label: t('order.status.partially_delivered') },
  { value: 'delivered', label: t('order.status.delivered') },
  { value: 'completed', label: t('order.status.completed') },
  { value: 'expired', label: t('order.status.expired') },
  { value: 'canceled', label: t('order.status.canceled') },
])

const hasActiveFilters = computed(() => Boolean(filters.orderNo || filters.status))

const currentStatusLabel = computed(() => {
  const selected = statusOptions.value.find((item) => item.value === filters.status)
  return selected?.label || t('orders.filters.statusAll')
})

const pendingPaymentCount = computed(() => orders.value.filter((order) => order.status === 'pending_payment').length)

const finishedCount = computed(() =>
  orders.value.filter((order) => order.status === 'delivered' || order.status === 'completed').length,
)

const loadOrders = async (page = 1) => {
  loading.value = true
  try {
    const response = await userOrderAPI.list({
      page,
      page_size: pagination.value.page_size,
      status: filters.status || undefined,
      order_no: filters.orderNo || undefined,
    })
    orders.value = response.data.data || []
    pagination.value = response.data.pagination || pagination.value
  } catch {
    orders.value = []
  } finally {
    loading.value = false
  }
}

const debouncedLoadOrders = debounceAsync(loadOrders, 300)

const changePage = (page: number) => {
  if (page < 1 || page > pagination.value.total_page) return
  debouncedLoadOrders(page)
}

const applyFilters = () => {
  loadOrders(1)
}

const handleOrderNoInput = () => {
  debouncedLoadOrders(1)
}

const handleStatusChange = () => {
  loadOrders(1)
}

const resetFilters = () => {
  filters.orderNo = ''
  filters.status = ''
  loadOrders(1)
}

const refreshCurrentPage = () => {
  loadOrders(pagination.value.page)
}

const statusLabel = (status: string) => orderStatusLabel(t, status)
const statusClass = (status: string) => orderStatusClass(status)

const formatMoney = (amount?: string, currency?: string) => {
  if (amount === null || amount === undefined || amount === '') return '-'
  if (currency === null || currency === undefined || currency === '') return String(amount)
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

const formatDate = (raw?: string) => {
  if (!raw) return ''
  const date = new Date(raw)
  if (Number.isNaN(date.getTime())) return raw
  return date.toLocaleString()
}

onMounted(() => {
  debouncedLoadOrders(1)
})

onUnmounted(() => {
  debouncedLoadOrders.cancel()
})
</script>
