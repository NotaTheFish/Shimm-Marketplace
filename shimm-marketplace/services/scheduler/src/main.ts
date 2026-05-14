import { createLogger } from "@shimm/logger";
import { registerDealChatExpirationCron } from "./cron/deal-chat-expiration.cron.js";
import { registerInviteExpirationCron } from "./cron/invite-expiration.cron.js";
import { registerBroadcastRotationCron } from "./cron/broadcast-rotation.cron.js";
import { registerVipPinRotationCron } from "./cron/vip-pin-rotation.cron.js";
import { registerAdExpirationCron } from "./cron/ad-expiration.cron.js";
import { registerReconciliationCron } from "./cron/reconciliation.cron.js";
import { registerTrustScoreRecalcCron } from "./cron/trust-score-recalc.cron.js";
import { registerRateLimitCleanupCron } from "./cron/rate-limit-cleanup.cron.js";
import { registerBackupCheckCron } from "./cron/backup-check.cron.js";

async function main() {
  const log = createLogger("scheduler");
  registerDealChatExpirationCron(log);
  registerInviteExpirationCron(log);
  registerBroadcastRotationCron(log);
  registerVipPinRotationCron(log);
  registerAdExpirationCron(log);
  registerReconciliationCron(log);
  registerTrustScoreRecalcCron(log);
  registerRateLimitCleanupCron(log);
  registerBackupCheckCron(log);
  log.info("scheduler_started");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
