const ru = {
  welcome: "Добро пожаловать в Shimm Marketplace.",
  maintenance: "Платформа на техническом обслуживании. Скоро вернёмся.",
} as const;

export type LocaleKey = keyof typeof ru;

export function t(key: LocaleKey, _locale: "ru" | "en" = "ru"): string {
  return ru[key] ?? key;
}
