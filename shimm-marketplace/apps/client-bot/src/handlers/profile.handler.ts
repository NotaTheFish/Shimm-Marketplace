import type { Bot } from "grammy";

export function registerProfile(bot: Bot) {
  bot.command("profile", async (ctx) => {
    await ctx.reply("Профиль: в разработке (Блок 2).");
  });
}
