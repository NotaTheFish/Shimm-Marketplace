import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerVipPinRotationCron(log: Logger) {
  cron.schedule("0 * * * *", () => log.debug("cron: vip_pin_rotation"));
}
