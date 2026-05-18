export type PlanTier = 'one_year' | 'two_year' | 'lifetime';

export const PLAN_TIERS: readonly PlanTier[] = [
  'one_year',
  'two_year',
  'lifetime',
] as const;

export function planTierToDays(tier: PlanTier): number {
  switch (tier) {
    case 'one_year':
      return 365;
    case 'two_year':
      return 730;
    case 'lifetime':
      return 3650;
    default:
      return 365;
  }
}

export function isPlanTier(v: string): v is PlanTier {
  return (PLAN_TIERS as readonly string[]).includes(v);
}

export type LocaleMap = Record<string, string>;

export function pickLocaleText(
  map: unknown,
  locale?: string,
): string {
  if (!map || typeof map !== 'object' || Array.isArray(map)) return '';
  const m = map as Record<string, unknown>;
  const loc = (locale ?? 'en').toLowerCase().split('-')[0];
  for (const key of [loc, 'fa', 'ps', 'en']) {
    const v = m[key];
    if (typeof v === 'string' && v.trim()) return v.trim();
  }
  for (const v of Object.values(m)) {
    if (typeof v === 'string' && v.trim()) return v.trim();
  }
  return '';
}
