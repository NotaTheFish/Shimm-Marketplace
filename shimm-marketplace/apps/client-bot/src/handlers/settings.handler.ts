import type { Bot } from "grammy";

export function registerSettings(bot: Bot) {
  bot.command("settings", async (ctx) => {
    await ctx.reply("Настройки: в разработке (Блок 28).");
  });
}
