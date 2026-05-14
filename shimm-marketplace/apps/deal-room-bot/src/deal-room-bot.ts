import type { Bot, Context } from "grammy";
import type { Logger } from "@shimm/logger";
import { createGrammyBot } from "@shimm/telegram";
import { createLogger } from "@shimm/logger";
import { registerJoin } from "./handlers/join.handler.js";
import { registerRules } from "./handlers/rules.handler.js";
import { registerCompletion } from "./handlers/completion.handler.js";
import { registerGuarantor } from "./handlers/guarantor.handler.js";
import { registerScamReport } from "./handlers/scam-report.handler.js";
import { registerAdminJoin } from "./handlers/admin-join.handler.js";
import { registerClose } from "./handlers/close.handler.js";

export function createDealRoomBot(token: string): { bot: Bot; log: Logger } {
  const bot = createGrammyBot(token);
  const log = createLogger("deal-room-bot");
  registerJoin(bot);
  registerRules(bot);
  registerCompletion(bot);
  registerGuarantor(bot);
  registerScamReport(bot);
  registerAdminJoin(bot);
  registerClose(bot);
  bot.command("start", async (ctx: Context) => {
    await ctx.reply("Deal-room bot (sub-bot чатов сделок).");
  });
  return { bot, log };
}
