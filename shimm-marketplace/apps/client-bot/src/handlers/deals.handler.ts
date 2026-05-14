import type { Bot } from "grammy";

export function registerDeals(bot: Bot) {
  bot.command("deals", async (ctx) => {
    await ctx.reply("Сделки: в разработке (Блок 1).");
  });
}
