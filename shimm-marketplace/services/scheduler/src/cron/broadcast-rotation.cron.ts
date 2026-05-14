import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerBroadcastRotationCron(log: Logger) {
  cron.schedule("0 * * * *", () => log.debug("cron: broadcast_rotation"));
}
