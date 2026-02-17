export type TranslateFn = (...args: any[]) => string

export const orderStatusLabel = (t: TranslateFn, status?: string) => {
  if (!status) return '-'
  const map: Record<string, string> = {
    pending_payment: t('order.status.pending_payment'),
    paid: t('order.status.paid'),
    fulfilling: t('order.status.fulfilling'),
    partially_delivered: t('order.status.partially_delivered'),
    delivered: t('order.status.delivered'),
    completed: t('order.status.completed'),
    expired: t('order.status.expired'),
    canceled: t('order.status.canceled'),
  }
  return map[status] || status
}

export const orderStatusClass = (status?: string) => {
  switch (status) {
    case 'pending_payment':
      return 'text-amber-700 border-amber-200 bg-amber-50'
    case 'paid':
      return 'text-emerald-700 border-emerald-200 bg-emerald-50'
    case 'partially_delivered':
      return 'text-orange-700 border-orange-200 bg-orange-50'
    case 'delivered':
    case 'completed':
      return 'text-slate-800 border-slate-200 bg-slate-50'
    case 'expired':
      return 'text-red-600 border-red-200 bg-red-50'
    case 'canceled':
      return 'text-slate-500 border-slate-200 bg-slate-50'
    default:
      return 'text-slate-600 border-slate-200 bg-slate-50'
  }
}
