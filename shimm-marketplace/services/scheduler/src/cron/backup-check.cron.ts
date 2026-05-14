import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerBackupCheckCron(log: Logger) {
  cron.schedule("0 */6 * * *", () => log.debug("cron: backup_check"));
}
