import type { Bot } from "grammy";

export function registerMarket(bot: Bot) {
  bot.command("market", async (ctx) => {
    await ctx.reply("Рынок: в разработке (Блок 9–10).");
  });
}
