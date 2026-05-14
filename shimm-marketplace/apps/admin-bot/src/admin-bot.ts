import type { Bot, Context } from "grammy";
import type { Logger } from "@shimm/logger";
import { createGrammyBot } from "@shimm/telegram";
import { loadConfig } from "@shimm/config";
import { createLogger } from "@shimm/logger";
import { ownerOnlyMiddleware } from "./middlewares/owner-only.middleware.js";
import { rbacMiddleware } from "./middlewares/rbac.middleware.js";
import { auditMiddleware } from "./middlewares/audit.middleware.js";
import { registerUsersAdmin } from "./handlers/users.admin.js";
import { registerModerationAdmin } from "./handlers/moderation.admin.js";
import { registerDisputesAdmin } from "./handlers/disputes.admin.js";
import { registerFinanceAdmin } from "./handlers/finance.admin.js";
import { registerAntifraudAdmin } from "./handlers/antifraud.admin.js";
import { registerAdsAdmin } from "./handlers/ads.admin.js";
import { registerLogsAdmin } from "./handlers/logs.admin.js";
import { registerAdminsAdmin } from "./handlers/admins.admin.js";
import { registerEmergencyAdmin } from "./handlers/emergency.admin.js";
import { registerSettingsAdmin } from "./handlers/settings.admin.js";

export function createAdminBot(token: string): { bot: Bot; log: Logger } {
  const bot = createGrammyBot(token);
  const config = loadConfig();
  const log = createLogger("admin-bot");

  bot.use(auditMiddleware());
  bot.use(ownerOnlyMiddleware(config.OWNER_TELEGRAM_IDS));
  bot.use(rbacMiddleware());

  registerUsersAdmin(bot);
  registerModerationAdmin(bot);
  registerDisputesAdmin(bot);
  registerFinanceAdmin(bot);
  registerAntifraudAdmin(bot);
  registerAdsAdmin(bot);
  registerLogsAdmin(bot);
  registerAdminsAdmin(bot);
  registerEmergencyAdmin(bot);
  registerSettingsAdmin(bot);

  bot.command("start", async (ctx: Context) => {
    await ctx.reply("Admin bot. Используйте команды из меню (заглушки).");
  });

  return { bot, log };
}
