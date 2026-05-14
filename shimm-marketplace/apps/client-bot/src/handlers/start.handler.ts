import type { Bot } from "grammy";
import type { UserService } from "@shimm/core";
import { t } from "@shimm/i18n";

export function registerStart(bot: Bot, users: UserService) {
  bot.command("start", async (ctx) => {
    const from = ctx.from;
    if (!from) return;
    await users.ensureFromTelegram({
      telegramUserId: BigInt(from.id),
      username: from.username,
      firstName: from.first_name,
      lastName: from.last_name,
      languageCode: from.language_code,
    });
    await ctx.reply(t("welcome"));
  });
}
