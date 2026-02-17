<template>
  <div class="relative flex min-h-screen items-center justify-center overflow-hidden bg-gray-50 px-4 py-16 dark:bg-[#0a0a0a] sm:px-6">
    <div class="pointer-events-none absolute inset-x-0 top-0 h-[52vh] bg-[radial-gradient(circle_at_top,rgba(99,102,241,0.14),transparent_62%)] dark:bg-[radial-gradient(circle_at_top,rgba(129,140,248,0.22),transparent_62%)]"></div>
    <div class="pointer-events-none absolute inset-x-0 bottom-0 h-[52vh] bg-[radial-gradient(circle_at_bottom,rgba(6,182,212,0.14),transparent_62%)] dark:bg-[radial-gradient(circle_at_bottom,rgba(34,211,238,0.2),transparent_62%)]"></div>
    <div class="pointer-events-none absolute -left-24 top-20 h-72 w-72 rounded-full bg-indigo-300/20 blur-3xl dark:bg-indigo-500/20"></div>
    <div class="pointer-events-none absolute -right-24 bottom-12 h-72 w-72 rounded-full bg-cyan-300/20 blur-3xl dark:bg-cyan-500/20"></div>

    <div class="relative z-10 w-full max-w-lg">
      <div class="mb-4 flex items-center justify-between px-1">
        <router-link
          to="/"
          class="inline-flex items-center gap-1 rounded-full border border-gray-200 bg-white/90 px-3 py-1 text-xs font-semibold text-gray-600 transition-colors hover:border-indigo-300 hover:text-indigo-600 dark:border-white/10 dark:bg-[#111]/70 dark:text-gray-300 dark:hover:border-indigo-500/40 dark:hover:text-indigo-200"
        >
          ← {{ t('auth.login.backHome') }}
        </router-link>
        <span class="rounded-full border border-gray-200 bg-white/90 px-3 py-1 text-xs font-semibold text-gray-500 dark:border-white/10 dark:bg-[#111]/70 dark:text-gray-300">
          {{ t('navbar.personalCenter') }}
        </span>
      </div>

      <div class="rounded-3xl border border-gray-200/80 bg-white/95 p-6 shadow-[0_24px_70px_-40px_rgba(15,23,42,0.45)] backdrop-blur-sm dark:border-white/10 dark:bg-[#111]/90 sm:p-8">
        <div class="mb-7 text-center">
          <p class="text-xs font-semibold uppercase tracking-[0.22em] text-indigo-500/85 dark:text-indigo-300/80">Dujiao-Next · D&N</p>
          <h1 class="mt-3 text-3xl font-black text-gray-900 dark:text-white">{{ t('auth.login.title') }}</h1>
          <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">{{ t('auth.login.subtitle') }}</p>
        </div>

        <form class="space-y-5" @submit.prevent="handleLogin">
          <div>
            <label class="mb-2 block text-xs font-semibold uppercase tracking-[0.18em] text-gray-500 dark:text-gray-400">
              {{ t('auth.login.emailLabel') }}
            </label>
            <input
              v-model="email"
              type="email"
              required
              class="w-full rounded-xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-700 transition-colors focus:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 dark:border-white/10 dark:bg-black/20 dark:text-gray-100 dark:focus:border-indigo-500/40"
              :placeholder="t('auth.login.emailPlaceholder')"
            />
          </div>

          <div>
            <label class="mb-2 block text-xs font-semibold uppercase tracking-[0.18em] text-gray-500 dark:text-gray-400">
              {{ t('auth.login.passwordLabel') }}
            </label>
            <input
              v-model="password"
              type="password"
              required
              class="w-full rounded-xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-700 transition-colors focus:border-indigo-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 dark:border-white/10 dark:bg-black/20 dark:text-gray-100 dark:focus:border-indigo-500/40"
              :placeholder="t('auth.login.passwordPlaceholder')"
            />
          </div>

          <div v-if="loginCaptchaEnabled">
            <label class="mb-2 block text-xs font-semibold uppercase tracking-[0.18em] text-gray-500 dark:text-gray-400">
              {{ t('auth.common.captchaLabel') }}
            </label>
            <ImageCaptcha
              v-if="captchaProvider === 'image'"
              ref="imageCaptchaRef"
              v-model="captchaPayload"
              :disabled="userAuthStore.loading"
              @config-stale="handleCaptchaConfigStale"
            />
            <TurnstileCaptcha
              v-else-if="captchaProvider === 'turnstile'"
              ref="turnstileRef"
              v-model="turnstileToken"
              :site-key="turnstileSiteKey"
            />
          </div>

          <div class="flex flex-wrap items-center justify-between gap-2 text-xs text-gray-500 dark:text-gray-400">
            <label class="inline-flex items-center gap-2">
              <input v-model="rememberMe" type="checkbox" class="h-4 w-4 accent-indigo-500" />
              {{ t('auth.login.rememberMe') }}
            </label>
            <router-link
              to="/auth/forgot"
              class="font-medium text-gray-600 transition-colors hover:text-indigo-600 dark:text-gray-300 dark:hover:text-indigo-200"
            >
              {{ t('auth.login.forgot') }}
            </router-link>
          </div>

          <div
            v-if="info"
            class="rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-center text-sm text-emerald-700 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-200"
          >
            {{ info }}
          </div>

          <div
            v-if="error"
            class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-center text-sm text-red-500 dark:border-red-500/30 dark:bg-red-500/10 dark:text-red-300"
          >
            {{ error }}
          </div>

          <button
            type="submit"
            :disabled="userAuthStore.loading"
            class="inline-flex w-full items-center justify-center rounded-xl bg-gray-900 px-4 py-3 text-sm font-bold text-white transition-colors hover:bg-gray-800 disabled:cursor-not-allowed disabled:opacity-50 dark:bg-white dark:text-black dark:hover:bg-gray-200"
          >
            {{ userAuthStore.loading ? t('auth.login.submitting') : t('auth.login.submit') }}
          </button>
        </form>
      </div>

      <div class="mt-4 text-center">
        <router-link
          to="/auth/register"
          class="text-sm text-gray-500 transition-colors hover:text-indigo-600 dark:text-gray-400 dark:hover:text-indigo-200"
        >
          {{ t('auth.login.noAccount') }}
        </router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserAuthStore } from '../../stores/userAuth'
import { useI18n } from 'vue-i18n'
import { debounceAsync } from '../../utils/debounce'
import { useAppStore } from '../../stores/app'
import type { CaptchaPayload } from '../../api'
import ImageCaptcha from '../../components/captcha/ImageCaptcha.vue'
import TurnstileCaptcha from '../../components/captcha/TurnstileCaptcha.vue'

const router = useRouter()
const route = useRoute()
const userAuthStore = useUserAuthStore()
const appStore = useAppStore()
const { t } = useI18n()

const email = ref('')
const password = ref('')
const rememberMe = ref(true)
const error = ref('')
const info = ref('')
const captchaPayload = ref<CaptchaPayload>({})
const turnstileToken = ref('')
const imageCaptchaRef = ref<InstanceType<typeof ImageCaptcha> | null>(null)
const turnstileRef = ref<InstanceType<typeof TurnstileCaptcha> | null>(null)

const captchaConfig = computed(() => appStore.config?.captcha || null)
const captchaProvider = computed(() => String(captchaConfig.value?.provider || 'none'))
const loginCaptchaEnabled = computed(() => !!captchaConfig.value?.scenes?.login && captchaProvider.value !== 'none')
const turnstileSiteKey = computed(() => String(captchaConfig.value?.turnstile?.site_key || ''))

const getCaptchaPayload = (): CaptchaPayload | undefined => {
  if (!loginCaptchaEnabled.value) return undefined
  if (captchaProvider.value === 'image') {
    return {
      captcha_id: captchaPayload.value.captcha_id || '',
      captcha_code: captchaPayload.value.captcha_code || '',
    }
  }
  if (captchaProvider.value === 'turnstile') {
    return {
      turnstile_token: turnstileToken.value,
    }
  }
  return undefined
}

const handleCaptchaConfigStale = async () => {
  await appStore.loadConfig(true)
  captchaPayload.value = {}
  turnstileToken.value = ''
}

const performLogin = async () => {
  error.value = ''
  if (!email.value || !password.value) return

  if (loginCaptchaEnabled.value && captchaProvider.value === 'image') {
    if (!captchaPayload.value.captcha_id || !captchaPayload.value.captcha_code) {
      error.value = t('auth.common.captchaRequired')
      return
    }
  }

  if (loginCaptchaEnabled.value && captchaProvider.value === 'turnstile') {
    if (!turnstileToken.value) {
      error.value = t('auth.common.captchaRequired')
      return
    }
  }

  try {
    await userAuthStore.login({
      email: email.value,
      password: password.value,
      remember_me: rememberMe.value,
      captcha_payload: getCaptchaPayload(),
    })
    const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : '/me/orders'
    router.push(redirect)
  } catch (err: any) {
    error.value = err.message || t('auth.login.error')
    if (captchaProvider.value === 'image') {
      imageCaptchaRef.value?.refresh()
    }
    if (captchaProvider.value === 'turnstile') {
      turnstileRef.value?.reset()
      turnstileToken.value = ''
    }
  }
}

const handleLogin = debounceAsync(performLogin, 200)

onMounted(async () => {
  await appStore.loadConfig(true)

  const reason = typeof route.query.reason === 'string' ? route.query.reason : ''
  if (reason === 'password_changed') {
    info.value = t('auth.login.passwordChangedTip')
    const nextQuery = { ...route.query }
    delete nextQuery.reason
    router.replace({ path: route.path, query: nextQuery })
  }
})
</script>
