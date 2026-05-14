import type { Bot } from "grammy";

export function registerAdsAdmin(bot: Bot) {
  bot.command("ads", async (c) => {
    await c.reply("ads: заглушка (Блок 21).");
  });
}
