<template>
  <div class="relative min-h-screen overflow-hidden bg-gray-50 pt-24 pb-16 text-gray-900 dark:bg-[#0a0a0a] dark:text-white">
    <div class="pointer-events-none absolute inset-x-0 top-0 h-72 bg-[radial-gradient(circle_at_top,rgba(99,102,241,0.14),transparent_62%)] dark:bg-[radial-gradient(circle_at_top,rgba(129,140,248,0.22),transparent_62%)]"></div>
    <div class="pointer-events-none absolute -right-20 top-40 h-64 w-64 rounded-full bg-indigo-300/20 blur-3xl dark:bg-indigo-400/20"></div>

    <div class="container relative z-10 mx-auto px-4">
      <header class="mb-8 rounded-3xl border border-gray-200/70 bg-white/95 p-6 shadow-[0_18px_50px_-30px_rgba(15,23,42,0.45)] backdrop-blur-sm dark:border-white/10 dark:bg-[#111]/90 lg:p-8">
        <div class="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.24em] text-indigo-500/80 dark:text-indigo-300/80">
              {{ t('personalCenter.title') }}
            </p>
            <h1 class="mt-3 text-3xl font-black text-gray-900 dark:text-white lg:text-[2.1rem]">{{ userProfileStore.displayName }}</h1>
            <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">{{ t('personalCenter.subtitle') }}</p>
          </div>

          <div class="grid grid-cols-1 gap-3 sm:grid-cols-3 lg:w-auto">
            <div class="rounded-2xl border border-gray-200 bg-gray-50/90 px-4 py-3 dark:border-white/10 dark:bg-white/5">
              <p class="text-[11px] uppercase tracking-[0.16em] text-gray-400">{{ t('personalCenter.tabs.overview') }}</p>
              <p class="mt-2 text-sm font-semibold text-gray-700 dark:text-gray-100">{{ currentSectionLabel }}</p>
            </div>
            <div class="rounded-2xl border border-gray-200 bg-gray-50/90 px-4 py-3 dark:border-white/10 dark:bg-white/5">
              <p class="text-[11px] uppercase tracking-[0.16em] text-gray-400">{{ t('personalCenter.tabs.orders') }}</p>
              <p class="mt-2 text-sm font-semibold text-gray-700 dark:text-gray-100">
                {{ userProfileStore.loadingOrders ? '-' : userProfileStore.recentOrders.length }}
              </p>
            </div>
            <div class="rounded-2xl border border-gray-200 bg-gray-50/90 px-4 py-3 dark:border-white/10 dark:bg-white/5">
              <p class="text-[11px] uppercase tracking-[0.16em] text-gray-400">{{ t('personalCenter.overview.accountLabel') }}</p>
              <span class="mt-2 inline-flex rounded-full border px-2.5 py-1 text-xs font-semibold" :class="emailVerifiedClass">
                {{ emailVerifiedLabel }}
              </span>
            </div>
          </div>
        </div>
      </header>

      <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
        <aside class="lg:col-span-3">
          <div class="rounded-2xl border border-gray-200/80 bg-white/90 p-4 shadow-sm backdrop-blur-sm dark:border-white/10 dark:bg-[#111]/85 lg:sticky lg:top-24">
            <div class="hidden flex-col gap-2 lg:flex">
              <button
                v-for="item in sectionItems"
                :key="item.key"
                type="button"
                @click="switchSection(item.key)"
                class="group w-full rounded-xl border px-4 py-3 text-left text-sm font-medium transition-all"
                :class="currentSection === item.key
                  ? 'border-indigo-200 bg-indigo-50 text-indigo-700 shadow-[0_10px_25px_-18px_rgba(79,70,229,0.85)] dark:border-indigo-500/30 dark:bg-indigo-500/12 dark:text-indigo-200'
                  : 'border-gray-200 bg-gray-50 text-gray-600 hover:border-indigo-200 hover:text-indigo-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200'"
              >
                <span class="flex items-center justify-between gap-3">
                  <span>{{ t(item.label) }}</span>
                  <span
                    class="h-1.5 w-1.5 rounded-full transition-colors"
                    :class="currentSection === item.key ? 'bg-indigo-500 dark:bg-indigo-300' : 'bg-gray-300 dark:bg-gray-600 group-hover:bg-indigo-400 dark:group-hover:bg-indigo-300'"
                  ></span>
                </span>
              </button>
            </div>

            <div class="lg:hidden">
              <div class="flex gap-2 overflow-x-auto pb-1">
                <button
                  v-for="item in sectionItems"
                  :key="item.key"
                  type="button"
                  @click="switchSection(item.key)"
                  class="shrink-0 rounded-lg border px-4 py-2 text-xs font-semibold transition-colors"
                  :class="currentSection === item.key
                    ? 'border-indigo-200 bg-indigo-50 text-indigo-600 dark:border-indigo-500/30 dark:bg-indigo-500/10 dark:text-indigo-200'
                    : 'border-gray-200 bg-white text-gray-600 dark:border-white/10 dark:bg-white/5 dark:text-gray-300'"
                >
                  {{ t(item.label) }}
                </button>
              </div>
            </div>
          </div>
        </aside>

        <section class="space-y-6 lg:col-span-9">
          <div
            v-if="globalAlert"
            class="rounded-2xl border px-4 py-3 text-sm shadow-sm"
            :class="pageAlertClass(globalAlert.level)"
          >
            {{ globalAlert.message }}
          </div>

          <template v-if="currentSection === 'overview'">
            <div class="rounded-2xl border border-gray-200/80 bg-white/95 p-6 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
              <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                <div class="flex items-center gap-4">
                  <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-indigo-50 text-lg font-black text-indigo-600 dark:bg-indigo-500/20 dark:text-indigo-200">
                    {{ displayInitial }}
                  </div>
                  <div>
                    <p class="text-xs uppercase tracking-[0.18em] text-gray-500">{{ t('personalCenter.overview.accountLabel') }}</p>
                    <h2 class="mt-1 text-xl font-black text-gray-900 dark:text-white">{{ userProfileStore.displayName }}</h2>
                    <p class="mt-1 text-sm text-gray-500 dark:text-gray-300">{{ userProfileStore.profile?.email || '-' }}</p>
                  </div>
                </div>
                <span class="inline-flex items-center rounded-full border px-3 py-1 text-xs font-semibold" :class="emailVerifiedClass">
                  {{ emailVerifiedLabel }}
                </span>
              </div>
            </div>

            <div class="rounded-2xl border border-gray-200/80 bg-white/95 p-6 shadow-sm dark:border-white/10 dark:bg-[#111]/85">
              <div class="mb-4 flex flex-wrap items-center justify-between gap-2">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ t('personalCenter.overview.recentOrdersTitle') }}</h3>
                <router-link
                  to="/me/orders"
                  class="inline-flex items-center rounded-full border border-gray-200 px-3 py-1 text-xs font-semibold text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
                >
                  {{ t('personalCenter.overview.viewAllOrders') }}
                </router-link>
              </div>

              <div v-if="userProfileStore.loadingOrders" class="space-y-3">
                <div
                  v-for="idx in 3"
                  :key="idx"
                  class="h-16 animate-pulse rounded-xl border border-gray-200 bg-gray-100 dark:border-white/10 dark:bg-white/5"
                ></div>
              </div>

              <div v-else-if="userProfileStore.recentOrders.length === 0" class="rounded-xl border border-dashed border-gray-200 bg-gray-50 px-4 py-5 text-sm text-gray-500 dark:border-white/10 dark:bg-white/5 dark:text-gray-400">
                {{ t('personalCenter.overview.emptyOrders') }}
              </div>

              <div v-else class="space-y-3">
                <div
                  v-for="order in userProfileStore.recentOrders"
                  :key="order.order_no || order.id"
                  class="rounded-xl border border-gray-200 bg-gray-50/90 px-4 py-3 transition-all hover:-translate-y-0.5 hover:border-indigo-200 hover:shadow-[0_12px_24px_-24px_rgba(79,70,229,0.9)] dark:border-white/10 dark:bg-white/5 dark:hover:border-indigo-500/35"
                >
                  <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                    <div>
                      <div class="text-xs text-gray-500">{{ t('orders.orderNo') }}：{{ order.order_no }}</div>
                      <div class="mt-1 text-sm font-semibold text-gray-900 dark:text-white">
                        {{ formatMoney(order.total_amount, order.currency) }}
                      </div>
                      <div class="mt-1 text-xs text-gray-500">{{ formatDate(order.created_at) }}</div>
                    </div>
                    <div class="flex flex-wrap items-center gap-2">
                      <span class="rounded-full border px-3 py-1 text-xs font-medium" :class="statusClass(order.status)">
                        {{ statusLabel(order.status) }}
                      </span>
                      <router-link
                        :to="`/orders/${order.order_no}`"
                        class="rounded-lg border border-gray-200 bg-white px-3 py-1.5 text-xs font-medium text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:bg-black/20 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
                      >
                        {{ t('orders.viewDetails') }}
                      </router-link>
                      <router-link
                        v-if="order.status === 'pending_payment'"
                        :to="`/pay?order_no=${order.order_no}`"
                        class="rounded-lg bg-gray-900 px-3 py-1.5 text-xs font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
                      >
                        {{ t('orders.payNow') }}
                      </router-link>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </template>

          <ProfilePanel v-else-if="currentSection === 'profile'" />
          <SecurityPanel v-else-if="currentSection === 'security'" />
          <OrdersPanel v-else />
        </section>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { orderStatusClass, orderStatusLabel } from '../utils/status'
import { pageAlertClass, type PageAlert } from '../utils/alerts'
import { useUserProfileStore } from '../stores/userProfile'
import ProfilePanel from './personal/ProfilePanel.vue'
import SecurityPanel from './personal/SecurityPanel.vue'
import OrdersPanel from './personal/OrdersPanel.vue'

type PersonalSection = 'overview' | 'profile' | 'security' | 'orders'

const props = withDefaults(defineProps<{ section?: PersonalSection }>(), {
  section: 'overview',
})

const router = useRouter()
const { t } = useI18n()
const userProfileStore = useUserProfileStore()

const sectionItems: Array<{ key: PersonalSection; label: string }> = [
  { key: 'overview', label: 'personalCenter.tabs.overview' },
  { key: 'profile', label: 'personalCenter.tabs.profile' },
  { key: 'security', label: 'personalCenter.tabs.security' },
  { key: 'orders', label: 'personalCenter.tabs.orders' },
]

const sectionRouteMap: Record<PersonalSection, string> = {
  overview: '/me',
  profile: '/me/profile',
  security: '/me/security',
  orders: '/me/orders',
}

const currentSection = computed<PersonalSection>(() => props.section)
const globalAlert = ref<PageAlert | null>(null)

const currentSectionLabel = computed(() => {
  const current = sectionItems.find((item) => item.key === currentSection.value)
  return current ? t(current.label) : t('personalCenter.title')
})

const displayInitial = computed(() => {
  const name = userProfileStore.displayName || ''
  const normalized = name.trim()
  if (!normalized) return 'U'
  return normalized.slice(0, 1).toUpperCase()
})

const switchSection = (section: PersonalSection) => {
  router.push(sectionRouteMap[section])
}

const statusLabel = (status?: string) => orderStatusLabel(t, status)
const statusClass = (status?: string) => orderStatusClass(status)

const formatMoney = (amount?: string, currency?: string) => {
  if (!amount) return '-'
  if (!currency) return amount
  return `${amount} ${currency}`
}

const formatDate = (raw?: string) => {
  if (!raw) return '-'
  const date = new Date(raw)
  if (Number.isNaN(date.getTime())) return raw
  return date.toLocaleString()
}

const emailVerifiedLabel = computed(() => {
  if (userProfileStore.profile?.email_verified_at) {
    return t('personalCenter.overview.emailVerified')
  }
  return t('personalCenter.overview.emailUnverified')
})

const emailVerifiedClass = computed(() => {
  if (userProfileStore.profile?.email_verified_at) {
    return 'border-emerald-200 bg-emerald-50 text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-200'
  }
  return 'border-amber-200 bg-amber-50 text-amber-700 dark:border-amber-500/30 dark:bg-amber-500/10 dark:text-amber-200'
})

const initialize = async () => {
  globalAlert.value = null
  const [profileOk] = await Promise.all([
    userProfileStore.loadProfile(),
    userProfileStore.loadRecentOrders(5),
  ])
  if (!profileOk) {
    globalAlert.value = {
      level: 'error',
      message: userProfileStore.profileError || t('personalCenter.common.loadFailed'),
    }
  }
}

onMounted(() => {
  initialize()
})
</script>
