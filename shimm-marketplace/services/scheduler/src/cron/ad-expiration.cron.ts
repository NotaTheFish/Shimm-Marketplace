import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerAdExpirationCron(log: Logger) {
  cron.schedule("0 * * * *", () => log.debug("cron: ad_expiration"));
}
