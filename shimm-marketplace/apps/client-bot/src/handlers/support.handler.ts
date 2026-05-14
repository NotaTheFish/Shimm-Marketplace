import type { Bot } from "grammy";

export function registerSupport(bot: Bot) {
  bot.command("support", async (ctx) => {
    await ctx.reply("Поддержка: в разработке (Блок 26).");
  });
}
