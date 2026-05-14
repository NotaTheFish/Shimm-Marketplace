import cron from "node-cron";
import type { Logger } from "@shimm/logger";

export function registerTrustScoreRecalcCron(log: Logger) {
  cron.schedule("0 0 * * *", () => log.debug("cron: trust_score_recalc"));
}
