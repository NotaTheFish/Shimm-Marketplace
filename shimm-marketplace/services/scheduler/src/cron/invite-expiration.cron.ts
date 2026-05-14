import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerInviteExpirationCron(log: Logger) {
  cron.schedule("*/15 * * * *", () => log.debug("cron: invite_expiration"));
}
