import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerReconciliationCron(log: Logger) {
  cron.schedule("0 */6 * * *", () => log.debug("cron: reconcile_finance"));
}
