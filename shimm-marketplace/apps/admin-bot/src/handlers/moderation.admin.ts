import type { Bot } from "grammy";

export function registerModerationAdmin(bot: Bot) {
  bot.command("moderation", async (c) => {
    await c.reply("moderation: заглушка (Блок 21).");
  });
}
