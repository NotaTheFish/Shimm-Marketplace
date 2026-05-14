import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerDealChatExpirationCron(log: Logger) {
  cron.schedule("*/15 * * * *", () => {
    log.debug("cron: check_deal_chat_ttl (Блок 1)");
  });
}
