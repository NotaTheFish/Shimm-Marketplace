/** Shared DTO / API contracts — extend as modules grow. */
export type BotKind = "client" | "admin" | "deal";

export type WebhookAck = { ok: true; queued: boolean };
