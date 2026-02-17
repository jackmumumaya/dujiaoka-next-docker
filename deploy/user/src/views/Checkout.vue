<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 dark:bg-[#0a0a0a] dark:text-white pt-24 pb-16">
    <div class="container mx-auto px-4">
      <div class="mb-8">
        <h1 class="mb-2 text-3xl font-black text-gray-900 dark:text-white">{{ t('checkout.title') }}</h1>
        <p class="text-sm text-gray-600 dark:text-gray-400">{{ t('checkout.subtitle') }}</p>
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
        <p class="mb-6 text-gray-500 dark:text-gray-400">{{ t('checkout.empty') }}</p>
        <router-link
          to="/products"
          class="inline-flex items-center gap-2 rounded-xl bg-gray-900 px-6 py-3 font-bold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-black dark:hover:bg-gray-200"
        >
          {{ t('checkout.emptyAction') }}
        </router-link>
      </div>

      <div v-else class="grid grid-cols-1 gap-8 lg:grid-cols-3">
        <div class="space-y-6 lg:col-span-2">
          <div class="rounded-2xl border border-gray-200 bg-white p-6 dark:border-white/10 dark:bg-[#111]/80">
            <h2 class="mb-4 text-lg font-bold text-gray-900 dark:text-white">{{ t('checkout.itemsTitle') }}</h2>
            <div class="space-y-4">
              <div
                v-for="item in cartItems"
                :key="item.productId"
                class="rounded-xl border border-gray-100 bg-gray-50 p-4 dark:border-white/10 dark:bg-black/20"
              >
                <div class="flex items-start justify-between gap-4">
                  <div>
                    <router-link
                      :to="`/products/${item.slug}`"
                      class="font-semibold text-gray-900 transition-colors hover:text-purple-600 dark:text-white dark:hover:text-purple-400"
                    >
                      {{ getLocalizedText(item.title) }}
                    </router-link>
                    <div class="mt-1 text-xs text-gray-500">{{ t('checkout.quantityLabel') }}：{{ item.quantity }}</div>
                    <div class="mt-2 flex flex-wrap gap-2">
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
                  <div class="text-right">
                    <div class="text-xs uppercase tracking-wider text-gray-500">{{ t('checkout.previewTotal') }}</div>
                    <div class="text-sm font-semibold text-gray-900 dark:text-white">{{ itemSubtotal(item) }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div
            v-if="manualFormProducts.length"
            class="rounded-2xl border border-gray-200 bg-white p-6 dark:border-white/10 dark:bg-[#111]/80"
          >
            <h2 class="mb-2 text-lg font-bold text-gray-900 dark:text-white">{{ t('checkout.manualFormTitle') }}</h2>
            <p class="mb-4 text-xs text-gray-500 dark:text-gray-400">{{ t('checkout.manualFormTip') }}</p>
            <div class="space-y-5">
              <div
                v-for="manualItem in manualFormProducts"
                :key="manualItem.productId"
                class="rounded-xl border border-gray-100 bg-gray-50 p-4 dark:border-white/10 dark:bg-black/20"
              >
                <h3 class="mb-3 text-sm font-semibold text-gray-900 dark:text-white">{{ getLocalizedText(manualItem.title) }}</h3>
                <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
                  <div v-for="field in manualItem.fields" :key="`${manualItem.productId}-${field.key}`" class="space-y-1.5">
                    <label class="text-xs font-semibold text-gray-600 dark:text-gray-300">
                      {{ getManualFieldLabel(field) }}
                      <span v-if="field.required" class="ml-1 text-red-500">*</span>
                    </label>

                    <textarea
                      v-if="field.type === 'textarea'"
                      v-model="ensureManualFormRow(manualItem.productId)[field.key]"
                      rows="3"
                      class="w-full rounded-xl border border-gray-200 bg-white px-3 py-2 text-sm text-gray-900 placeholder-gray-400 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white dark:placeholder-gray-600"
                      :placeholder="getManualFieldPlaceholder(field)"
                    />

                    <select
                      v-else-if="field.type === 'select'"
                      v-model="ensureManualFormRow(manualItem.productId)[field.key]"
                      class="w-full rounded-xl border border-gray-200 bg-white px-3 py-2 text-sm text-gray-900 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white"
                    >
                      <option value="">{{ t('checkout.manualFormSelectPlaceholder') }}</option>
                      <option v-for="option in field.options" :key="option" :value="option">{{ option }}</option>
                    </select>

                    <div v-else-if="field.type === 'radio'" class="space-y-2 rounded-xl border border-gray-200 bg-white p-3 dark:border-white/10 dark:bg-black/40">
                      <label v-for="option in field.options" :key="option" class="flex items-center gap-2 text-sm text-gray-700 dark:text-gray-200">
                        <input
                          v-model="ensureManualFormRow(manualItem.productId)[field.key]"
                          type="radio"
                          :name="`manual-radio-${manualItem.productId}-${field.key}`"
                          :value="option"
                          class="h-4 w-4"
                        />
                        <span>{{ option }}</span>
                      </label>
                    </div>

                    <div v-else-if="field.type === 'checkbox'" class="space-y-2 rounded-xl border border-gray-200 bg-white p-3 dark:border-white/10 dark:bg-black/40">
                      <label v-for="option in field.options" :key="option" class="flex items-center gap-2 text-sm text-gray-700 dark:text-gray-200">
                        <input
                          v-model="ensureManualFormRow(manualItem.productId)[field.key]"
                          type="checkbox"
                          :value="option"
                          class="h-4 w-4"
                        />
                        <span>{{ option }}</span>
                      </label>
                    </div>

                    <input
                      v-else
                      v-model="ensureManualFormRow(manualItem.productId)[field.key]"
                      :type="field.type === 'number' ? 'number' : field.type === 'email' ? 'email' : field.type === 'phone' ? 'tel' : 'text'"
                      class="w-full rounded-xl border border-gray-200 bg-white px-3 py-2 text-sm text-gray-900 placeholder-gray-400 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white dark:placeholder-gray-600"
                      :placeholder="getManualFieldPlaceholder(field)"
                    />

                    <p
                      v-if="submitAttempted && manualFieldError(manualItem.productId, field.key)"
                      class="text-xs text-red-500"
                    >
                      {{ manualFieldError(manualItem.productId, field.key) }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="rounded-2xl border border-gray-200 bg-white p-6 dark:border-white/10 dark:bg-[#111]/80">
            <h2 class="mb-4 text-lg font-bold text-gray-900 dark:text-white">{{ t('checkout.couponTitle') }}</h2>
            <input
              v-model="couponCode"
              type="text"
              class="w-full rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-gray-900 placeholder-gray-400 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white dark:placeholder-gray-600"
              :placeholder="t('checkout.couponPlaceholder')"
            />
          </div>

          <div
            v-if="!userAuthStore.isAuthenticated"
            class="space-y-4 rounded-2xl border border-gray-200 bg-white p-6 dark:border-white/10 dark:bg-[#111]/80"
          >
            <h2 class="text-lg font-bold text-gray-900 dark:text-white">{{ t('checkout.modeTitle') }}</h2>
            <div class="flex flex-wrap gap-3">
              <button
                @click="checkoutMode = 'guest'"
                class="rounded-lg border px-4 py-2 text-sm"
                :class="checkoutMode === 'guest'
                  ? 'border-purple-500 bg-purple-50 text-purple-600 dark:bg-purple-500/10 dark:text-white'
                  : 'border-gray-200 text-gray-500 dark:border-white/10 dark:text-gray-400'"
              >
                {{ t('checkout.guestPurchase') }}
              </button>
              <router-link
                to="/auth/login"
                class="rounded-lg border border-gray-200 px-4 py-2 text-sm text-gray-500 transition-colors hover:border-gray-300 hover:text-gray-900 dark:border-white/10 dark:text-gray-400 dark:hover:border-white/30 dark:hover:text-white"
              >
                {{ t('checkout.memberPurchase') }}
              </router-link>
            </div>

            <div v-if="checkoutMode === 'guest'" class="grid grid-cols-1 gap-4 md:grid-cols-2">
              <input
                v-model="guestEmail"
                type="email"
                class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-gray-900 placeholder-gray-400 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white dark:placeholder-gray-600"
                :placeholder="t('checkout.guestEmailPlaceholder')"
              />
              <input
                v-model="guestPassword"
                type="password"
                class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-3 text-gray-900 placeholder-gray-400 transition-colors focus:border-purple-500 focus:outline-none dark:border-white/10 dark:bg-black/40 dark:text-white dark:placeholder-gray-600"
                :placeholder="t('checkout.guestPasswordPlaceholder')"
              />
            </div>

            <div v-if="checkoutMode === 'guest' && guestCaptchaEnabled" class="space-y-2">
              <p class="text-xs font-semibold uppercase tracking-[0.14em] text-gray-500 dark:text-gray-400">{{ t('auth.common.captchaLabel') }}</p>
              <ImageCaptcha
                v-if="captchaProvider === 'image'"
                ref="guestImageCaptchaRef"
                v-model="guestCaptchaPayload"
                :disabled="submitting"
                @config-stale="handleGuestCaptchaConfigStale"
              />
              <TurnstileCaptcha
                v-else-if="captchaProvider === 'turnstile'"
                ref="guestTurnstileRef"
                v-model="guestTurnstileToken"
                :site-key="guestTurnstileSiteKey"
              />
            </div>

            <p v-if="checkoutMode === 'guest'" class="text-xs text-gray-500">
              {{ t('checkout.guestTip') }}
            </p>
            <p v-if="checkoutMode === 'guest' && guestEmail && !guestEmailValid" class="text-xs text-red-500">
              {{ t('error.email_invalid') }}
            </p>
          </div>
        </div>

        <div class="h-fit rounded-2xl border border-gray-200 bg-white p-6 lg:sticky lg:top-24 dark:border-white/10 dark:bg-[#111]/80">
          <h2 class="mb-4 text-lg font-bold text-gray-900 dark:text-white">{{ t('checkout.submitTitle') }}</h2>
          <div class="mb-4 rounded-lg border border-gray-100 bg-gray-50 p-3 text-xs text-gray-500 dark:border-white/10 dark:bg-black/20 dark:text-gray-400">
            {{ t('checkout.submitHint') }}
          </div>

          <div class="mb-4 space-y-3 text-sm text-gray-500 dark:text-gray-400">
            <div class="flex items-center justify-between">
              <span>{{ t('cart.itemsCount') }}</span>
              <span class="font-mono text-gray-900 dark:text-white">{{ totalItems }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span>{{ t('checkout.previewOriginal') }}</span>
              <span class="font-mono text-gray-900 dark:text-white">{{ formatPrice(previewOriginal, previewCurrency) }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span>{{ t('checkout.previewCoupon') }}</span>
              <span class="font-mono text-gray-900 dark:text-white">{{ formatPrice(previewCoupon, previewCurrency) }}</span>
            </div>
            <div class="flex items-center justify-between">
              <span>{{ t('checkout.previewPromotion') }}</span>
              <span class="font-mono text-gray-900 dark:text-white">{{ formatPrice(previewPromotion, previewCurrency) }}</span>
            </div>
            <div class="flex items-center justify-between border-t border-gray-100 pt-3 text-gray-900 dark:border-white/10 dark:text-white">
              <span class="font-semibold">{{ t('checkout.previewTotal') }}</span>
              <span class="font-mono text-lg font-bold">{{ formatPrice(previewTotal, previewCurrency) }}</span>
            </div>
          </div>

          <div v-if="previewLoading || couponRefreshing" class="mb-3 text-xs text-gray-500 dark:text-gray-400">
            {{ previewStatusText }}
          </div>
          <div
            v-if="checkoutAlert"
            class="mb-4 rounded-lg border p-3 text-sm"
            :class="pageAlertClass(checkoutAlert.level)"
          >
            {{ checkoutAlert.message }}
          </div>

          <button
            @click="handleSubmit"
            :disabled="!canSubmit"
            class="w-full rounded-xl bg-gray-900 py-3 font-bold text-white transition-colors hover:bg-gray-800 disabled:cursor-not-allowed disabled:opacity-50 dark:bg-white dark:text-black dark:hover:bg-gray-200"
          >
            {{ submitting ? t('checkout.submitting') : t('checkout.submitButton') }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useCartStore, type CartItem } from '../stores/cart'
import { useAppStore } from '../stores/app'
import { useUserAuthStore } from '../stores/userAuth'
import { guestOrderAPI, userOrderAPI, type CaptchaPayload } from '../api'
import { debounceAsync } from '../utils/debounce'
import { pageAlertClass, type PageAlert } from '../utils/alerts'
import ImageCaptcha from '../components/captcha/ImageCaptcha.vue'
import TurnstileCaptcha from '../components/captcha/TurnstileCaptcha.vue'

const router = useRouter()
const cartStore = useCartStore()
const appStore = useAppStore()
const userAuthStore = useUserAuthStore()
const { t } = useI18n()

const cartItems = computed(() => cartStore.items)
const totalItems = computed(() => cartStore.totalItems)
const couponCode = ref('')
const normalizedCouponCode = computed(() => couponCode.value.trim())
const submitting = ref(false)
const error = ref('')
const preview = ref<any>(null)
const previewLoading = ref(false)
const previewError = ref('')
const previewRequestId = ref(0)
const couponRefreshing = ref(false)

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

const previewCurrency = computed(() => preview.value?.currency || totalCurrency.value)
const previewOriginal = computed(() => preview.value?.original_amount ?? totalAmount.value)
const previewCoupon = computed(() => preview.value?.discount_amount ?? '0')
const previewPromotion = computed(() => preview.value?.promotion_discount_amount ?? '0')
const previewTotal = computed(() => preview.value?.total_amount ?? totalAmount.value)

const checkoutMode = ref<'guest' | 'member'>('guest')
const guestEmail = ref('')
const guestPassword = ref('')
const guestCaptchaPayload = ref<CaptchaPayload>({})
const guestTurnstileToken = ref('')
const guestImageCaptchaRef = ref<InstanceType<typeof ImageCaptcha> | null>(null)
const guestTurnstileRef = ref<InstanceType<typeof TurnstileCaptcha> | null>(null)

interface ManualFormField {
  key: string
  type: string
  required: boolean
  label?: Record<string, string>
  placeholder?: Record<string, string>
  regex?: string
  min?: number
  max?: number
  max_len?: number
  options: string[]
}

interface ManualFormProduct {
  productId: number
  title: any
  fields: ManualFormField[]
}

const manualFieldTypes = new Set(['text', 'textarea', 'phone', 'email', 'number', 'select', 'radio', 'checkbox'])
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
const phonePattern = /^\+?[0-9\-()\s]{6,20}$/
const findLastUnescapedSlash = (value: string) => {
  for (let index = value.length - 1; index > 0; index -= 1) {
    if (value[index] !== '/') {
      continue
    }
    let backslashes = 0
    for (let cursor = index - 1; cursor >= 0 && value[cursor] === '\\'; cursor -= 1) {
      backslashes += 1
    }
    if (backslashes % 2 === 0) {
      return index
    }
  }
  return -1
}

const compileManualRegex = (rawRegex?: string) => {
  const text = String(rawRegex || '').trim()
  if (!text) {
    return null
  }

  if (text.startsWith('/')) {
    const lastSlashIndex = findLastUnescapedSlash(text)
    if (lastSlashIndex > 0) {
      const pattern = text.slice(1, lastSlashIndex)
      const flags = text.slice(lastSlashIndex + 1)
      if (/^[gimsuy]*$/.test(flags)) {
        try {
          return new RegExp(pattern, flags)
        } catch {
          return null
        }
      }
    }
  }

  try {
    return new RegExp(text)
  } catch {
    return null
  }
}


const manualFormData = ref<Record<string, Record<string, any>>>({})
const submitAttempted = ref(false)

const normalizeManualFormSchema = (rawSchema: any): ManualFormField[] => {
  const rawFields = Array.isArray(rawSchema?.fields) ? rawSchema.fields : []
  return rawFields
    .map((rawField: any) => {
      const key = String(rawField?.key || '').trim()
      const type = String(rawField?.type || '').trim()
      if (!key || !manualFieldTypes.has(type)) {
        return null
      }
      const options = Array.isArray(rawField?.options)
        ? rawField.options.map((item: any) => String(item || '').trim()).filter(Boolean)
        : []
      const minValue = Number(rawField?.min)
      const maxValue = Number(rawField?.max)
      const maxLenValue = Number(rawField?.max_len)
      return {
        key,
        type,
        required: Boolean(rawField?.required),
        label: rawField?.label || undefined,
        placeholder: rawField?.placeholder || undefined,
        regex: String(rawField?.regex || '').trim() || undefined,
        min: Number.isFinite(minValue) ? minValue : undefined,
        max: Number.isFinite(maxValue) ? maxValue : undefined,
        max_len: Number.isFinite(maxLenValue) ? maxLenValue : undefined,
        options: Array.from(new Set(options)),
      } as ManualFormField
    })
    .filter(Boolean) as ManualFormField[]
}

const manualFormProducts = computed<ManualFormProduct[]>(() => cartItems.value
  .map((item) => {
    if (item.fulfillmentType !== 'manual') {
      return null
    }
    const fields = normalizeManualFormSchema(item.manualFormSchema)
    if (fields.length === 0) {
      return null
    }
    return {
      productId: item.productId,
      title: item.title,
      fields,
    }
  })
  .filter(Boolean) as ManualFormProduct[])

watch(manualFormProducts, (products) => {
  const nextData: Record<string, Record<string, any>> = {}
  products.forEach((product) => {
    const key = String(product.productId)
    const current = manualFormData.value[key] || {}
    const formValues: Record<string, any> = {}
    product.fields.forEach((field) => {
      const currentValue = current[field.key]
      if (field.type === 'checkbox') {
        formValues[field.key] = Array.isArray(currentValue)
          ? currentValue.map((item: any) => String(item)).filter(Boolean)
          : []
      } else {
        formValues[field.key] = currentValue == null ? '' : String(currentValue)
      }
    })
    nextData[key] = formValues
  })
  manualFormData.value = nextData
}, { immediate: true, deep: true })

const resolveLocalizedText = (jsonData?: Record<string, string>, fallback = '') => {
  if (!jsonData) return fallback
  const locale = appStore.locale
  return jsonData[locale] || jsonData['zh-CN'] || jsonData['en-US'] || fallback
}

const getManualFieldLabel = (field: ManualFormField) => {
  return resolveLocalizedText(field.label, field.key)
}

const getManualFieldPlaceholder = (field: ManualFormField) => {
  return resolveLocalizedText(field.placeholder, '')
}

const manualFieldErrorKey = (productId: number, fieldKey: string) => `${productId}:${fieldKey}`

const ensureManualFormRow = (productId: number) => {
  const key = String(productId)
  if (!manualFormData.value[key]) {
    manualFormData.value[key] = {}
  }
  return manualFormData.value[key]
}

const manualFormValidation = computed(() => {
  const errors: Record<string, string> = {}
  let firstError = ''

  const setError = (productId: number, field: ManualFormField, message: string) => {
    const errorKey = manualFieldErrorKey(productId, field.key)
    if (!errors[errorKey]) {
      errors[errorKey] = message
      if (!firstError) {
        firstError = message
      }
    }
  }

  manualFormProducts.value.forEach((product) => {
    const values = manualFormData.value[String(product.productId)] || {}
    product.fields.forEach((field) => {
      const fieldLabel = getManualFieldLabel(field)
      const rawValue = values[field.key]
      if (field.type === 'checkbox') {
        const list = Array.isArray(rawValue)
          ? rawValue.map((item: any) => String(item).trim()).filter(Boolean)
          : []
        if (field.required && list.length === 0) {
          setError(product.productId, field, t('checkout.manualFormFieldRequired', { name: fieldLabel }))
          return
        }
        if (list.length > 0 && field.options.length > 0 && list.some((item) => !field.options.includes(item))) {
          setError(product.productId, field, t('checkout.manualFormFieldOptionInvalid', { name: fieldLabel }))
        }
        return
      }

      const text = rawValue == null ? '' : String(rawValue).trim()
      if (field.required && !text) {
        setError(product.productId, field, t('checkout.manualFormFieldRequired', { name: fieldLabel }))
        return
      }
      if (!text) {
        return
      }

      if ((field.type === 'text' || field.type === 'textarea' || field.type === 'phone' || field.type === 'email') && field.max_len && text.length > field.max_len) {
        setError(product.productId, field, t('checkout.manualFormFieldMaxLength', { name: fieldLabel, max: field.max_len }))
        return
      }
      if ((field.type === 'phone' && !phonePattern.test(text)) || (field.type === 'email' && !emailPattern.test(text))) {
        setError(product.productId, field, t('checkout.manualFormFieldInvalid', { name: fieldLabel }))
        return
      }
      if (field.type === 'number') {
        const numberValue = Number(text)
        if (!Number.isFinite(numberValue)) {
          setError(product.productId, field, t('checkout.manualFormFieldNumberInvalid', { name: fieldLabel }))
          return
        }
        if ((field.min !== undefined && numberValue < field.min) || (field.max !== undefined && numberValue > field.max)) {
          setError(product.productId, field, t('checkout.manualFormFieldNumberRange', { name: fieldLabel }))
          return
        }
      }
      if ((field.type === 'select' || field.type === 'radio') && field.options.length > 0 && !field.options.includes(text)) {
        setError(product.productId, field, t('checkout.manualFormFieldOptionInvalid', { name: fieldLabel }))
        return
      }
      if (field.regex) {
        const regex = compileManualRegex(field.regex)
        if (!regex || !regex.test(text)) {
          setError(product.productId, field, t('checkout.manualFormFieldInvalid', { name: fieldLabel }))
        }
      }
    })
  })

  return {
    valid: Object.keys(errors).length === 0,
    errors,
    firstError,
  }
})

const manualFieldError = (productId: number, fieldKey: string) => {
  return manualFormValidation.value.errors[manualFieldErrorKey(productId, fieldKey)] || ''
}

const buildManualFormDataPayload = () => {
  const payload: Record<string, any> = {}
  manualFormProducts.value.forEach((product) => {
    const values = manualFormData.value[String(product.productId)] || {}
    const row: Record<string, any> = {}
    product.fields.forEach((field) => {
      const rawValue = values[field.key]
      if (field.type === 'checkbox') {
        const list = Array.isArray(rawValue)
          ? rawValue.map((item: any) => String(item).trim()).filter(Boolean)
          : []
        if (list.length > 0) {
          row[field.key] = list
        }
        return
      }
      const text = rawValue == null ? '' : String(rawValue).trim()
      if (text) {
        row[field.key] = text
      }
    })
    payload[String(product.productId)] = row
  })
  return payload
}

const manualFormFingerprint = computed(() => JSON.stringify(manualFormData.value))

const flowSteps = computed(() => ([
  { key: 'cart', label: t('cart.title'), active: false },
  { key: 'checkout', label: t('checkout.title'), active: true },
  { key: 'payment', label: t('payment.title'), active: false },
]))

const isGuestCheckout = computed(() => !userAuthStore.isAuthenticated && checkoutMode.value === 'guest')
const guestEmailValid = computed(() => {
  if (!isGuestCheckout.value) return true
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(guestEmail.value.trim())
})

const captchaConfig = computed(() => appStore.config?.captcha || null)
const captchaProvider = computed(() => String(captchaConfig.value?.provider || 'none'))
const guestCaptchaEnabled = computed(() => {
  if (!isGuestCheckout.value) return false
  return !!captchaConfig.value?.scenes?.guest_create_order && captchaProvider.value !== 'none'
})
const guestTurnstileSiteKey = computed(() => String(captchaConfig.value?.turnstile?.site_key || ''))

const getGuestCaptchaPayload = (): CaptchaPayload | undefined => {
  if (!guestCaptchaEnabled.value) return undefined
  if (captchaProvider.value === 'image') {
    return {
      captcha_id: guestCaptchaPayload.value.captcha_id || '',
      captcha_code: guestCaptchaPayload.value.captcha_code || '',
    }
  }
  if (captchaProvider.value === 'turnstile') {
    return {
      turnstile_token: guestTurnstileToken.value,
    }
  }
  return undefined
}

const handleGuestCaptchaConfigStale = async () => {
  await appStore.loadConfig(true)
  guestCaptchaPayload.value = {}
  guestTurnstileToken.value = ''
}

const canSubmit = computed(() => {
  if (submitting.value) return false
  if (cartItems.value.length === 0) return false
  if (!manualFormValidation.value.valid) return false
  if (userAuthStore.isAuthenticated) return true
  if (checkoutMode.value !== 'guest') return false
  if (!guestEmail.value.trim() || !guestPassword.value.trim() || !guestEmailValid.value) return false
  if (!guestCaptchaEnabled.value) return true
  if (captchaProvider.value === 'image') {
    return Boolean(guestCaptchaPayload.value.captcha_id && guestCaptchaPayload.value.captcha_code)
  }
  if (captchaProvider.value === 'turnstile') {
    return Boolean(guestTurnstileToken.value)
  }
  return false
})

const submitBlockedReason = computed(() => {
  if (cartItems.value.length === 0) return t('checkout.errors.emptyCart')
  if (!manualFormValidation.value.valid) {
    return manualFormValidation.value.firstError || t('checkout.errors.manualFormInvalid')
  }
  if (userAuthStore.isAuthenticated) return ''
  if (checkoutMode.value !== 'guest') return t('checkout.errors.loginOrGuest')
  if (!guestEmail.value.trim() || !guestPassword.value.trim()) return t('checkout.errors.missingGuest')
  if (!guestEmailValid.value) return t('error.email_invalid')
  if (guestCaptchaEnabled.value) {
    if (captchaProvider.value === 'image' && (!guestCaptchaPayload.value.captcha_id || !guestCaptchaPayload.value.captcha_code)) {
      return t('auth.common.captchaRequired')
    }
    if (captchaProvider.value === 'turnstile' && !guestTurnstileToken.value) {
      return t('auth.common.captchaRequired')
    }
  }
  return ''
})

const previewStatusText = computed(() => couponRefreshing.value
  ? t('checkout.couponRefreshing')
  : t('checkout.previewLoading'))

const checkoutAlert = computed<PageAlert | null>(() => {
  if (error.value) {
    return { level: 'error' as const, message: error.value }
  }
  if (previewError.value) {
    return { level: 'error' as const, message: previewError.value }
  }
  if (!canSubmit.value && submitBlockedReason.value) {
    return { level: 'warning' as const, message: submitBlockedReason.value }
  }
  return null
})

const buildItemsPayload = () => cartItems.value.map(item => ({
  product_id: item.productId,
  quantity: item.quantity,
  fulfillment_type: item.fulfillmentType || undefined,
}))

const buildOrderPayload = () => ({
  coupon_code: normalizedCouponCode.value || undefined,
  items: buildItemsPayload(),
  manual_form_data: buildManualFormDataPayload(),
})

const loadPreview = async () => {
  if (cartItems.value.length === 0) {
    preview.value = null
    previewError.value = ''
    couponRefreshing.value = false
    return
  }
  if (isGuestCheckout.value && (!guestEmail.value.trim() || !guestPassword.value.trim() || !guestEmailValid.value)) {
    preview.value = null
    previewError.value = ''
    couponRefreshing.value = false
    return
  }
  if (!manualFormValidation.value.valid) {
    preview.value = null
    previewError.value = ''
    couponRefreshing.value = false
    return
  }

  const requestId = ++previewRequestId.value
  previewLoading.value = true
  previewError.value = ''

  try {
    const payload: any = buildOrderPayload()

    let response
    if (userAuthStore.isAuthenticated) {
      response = await userOrderAPI.preview(payload)
    } else {
      response = await guestOrderAPI.preview({
        ...payload,
        email: guestEmail.value.trim(),
        order_password: guestPassword.value,
      })
    }

    if (requestId !== previewRequestId.value) return
    preview.value = response.data.data
  } catch (err: any) {
    if (requestId !== previewRequestId.value) return
    preview.value = null
    previewError.value = err.message || t('checkout.previewFailed')
  } finally {
    if (requestId === previewRequestId.value) {
      previewLoading.value = false
      couponRefreshing.value = false
    }
  }
}

const debouncedLoadPreview = debounceAsync(loadPreview, 300)

const loadPreviewNow = async () => {
  debouncedLoadPreview.cancel()
  await loadPreview()
}

const handleSubmit = async () => {
  submitAttempted.value = true
  error.value = ''
  previewError.value = ''
  if (!canSubmit.value) {
    error.value = submitBlockedReason.value || t('checkout.errors.submitFailed')
    return
  }

  submitting.value = true
  try {
    await loadPreviewNow()
    if (previewError.value) {
      error.value = previewError.value
      return
    }

    if (userAuthStore.isAuthenticated) {
      const response = await userOrderAPI.create(buildOrderPayload())
      const orderNo = String(response.data.data?.order_no || '').trim()
      if (!orderNo) {
        throw new Error(t('checkout.errors.submitFailed'))
      }
      cartStore.clear()
      router.push(`/pay?order_no=${encodeURIComponent(orderNo)}`)
      return
    }

    const response = await guestOrderAPI.create({
      ...buildOrderPayload(),
      email: guestEmail.value.trim(),
      order_password: guestPassword.value,
      captcha_payload: getGuestCaptchaPayload(),
    })

    localStorage.setItem('guest_order_auth', JSON.stringify({
      email: guestEmail.value.trim(),
      order_password: guestPassword.value,
    }))

    const orderNo = String(response.data.data?.order_no || '').trim()
    if (!orderNo) {
      throw new Error(t('checkout.errors.submitFailed'))
    }
    cartStore.clear()
    router.push(`/pay?guest=1&order_no=${encodeURIComponent(orderNo)}`)
  } catch (err: any) {
    error.value = err.message || t('checkout.errors.submitFailed')
    if (guestCaptchaEnabled.value && captchaProvider.value === 'image') {
      guestImageCaptchaRef.value?.refresh()
    }
    if (guestCaptchaEnabled.value && captchaProvider.value === 'turnstile') {
      guestTurnstileRef.value?.reset()
      guestTurnstileToken.value = ''
    }
  } finally {
    submitting.value = false
  }
}

watch(
  () => [cartItems.value, manualFormFingerprint.value, normalizedCouponCode.value, checkoutMode.value, guestEmail.value, guestPassword.value, userAuthStore.isAuthenticated],
  () => {
    debouncedLoadPreview()
  },
  { deep: true }
)

watch(normalizedCouponCode, (value, previous) => {
  if (value === previous) return
  couponRefreshing.value = true
  error.value = ''
  previewError.value = ''
})

onMounted(async () => {
  if (!appStore.config) {
    await appStore.loadConfig()
  }
  debouncedLoadPreview()
})

onUnmounted(() => {
  debouncedLoadPreview.cancel()
})

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
</script>
