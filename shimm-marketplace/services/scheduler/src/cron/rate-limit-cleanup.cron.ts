import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerRateLimitCleanupCron(log: Logger) {
  cron.schedule("*/15 * * * *", () => log.debug("cron: rate_limit_cleanup"));
}
