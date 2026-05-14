import type { Bot } from "grammy";

export function registerReviews(bot: Bot) {
  bot.command("reviews", async (ctx) => {
    await ctx.reply("Отзывы: в разработке (Блок 7).");
  });
}
