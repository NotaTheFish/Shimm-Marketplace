import "dotenv/config";
import { z } from "zod";

const envSchema = z.object({
  APP_ENV: z.enum(["development", "staging", "production"]).default("development"),
  APP_NAME: z.string().default("shimm-marketplace"),
  DATABASE_URL: z.string().min(1),
  REDIS_URL: z.string().optional(),
  LOG_LEVEL: z.string().default("info"),
  API_PORT: z.coerce.number().default(8000),
  OWNER_TELEGRAM_IDS: z.string().optional(),
  CLIENT_BOT_TOKEN: z.string().optional(),
  ADMIN_BOT_TOKEN: z.string().optional(),
  DEAL_ROOM_BOT_TOKEN: z.string().optional(),
  CLIENT_BOT_WEBHOOK_SECRET: z.string().optional(),
  ADMIN_BOT_WEBHOOK_SECRET: z.string().optional(),
  DEAL_BOT_WEBHOOK_SECRET: z.string().optional(),
  TELEGRAM_WEBHOOK_SECRET: z.string().optional(),
  JWT_SECRET: z.string().optional(),
  CALLBACK_SIGNING_SECRET: z.string().optional(),
  MINIAPP_SESSION_SECRET: z.string().optional(),
  MINIAPP_INIT_DATA_SECRET: z.string().optional(),
  ENCRYPTION_KEY: z.string().optional(),
  PUBLIC_MINIAPP_URL: z.string().optional(),
  PUBLIC_API_URL: z.string().optional(),
});

export type AppConfig = z.infer<typeof envSchema>;

let cached: AppConfig | null = null;

export function loadConfig(overrides?: Record<string, string | undefined>): AppConfig {
  if (cached && !overrides) return cached;
  const merged = { ...process.env, ...overrides };
  const parsed = envSchema.safeParse(merged);
  if (!parsed.success) {
    const msg = parsed.error.flatten().fieldErrors;
    throw new Error(`Invalid environment: ${JSON.stringify(msg)}`);
  }
  if (!overrides) cached = parsed.data;
  return parsed.data;
}

export function parseOwnerTelegramIds(raw?: string): bigint[] {
  if (!raw?.trim()) return [];
  return raw
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean)
    .map((s) => BigInt(s));
}
