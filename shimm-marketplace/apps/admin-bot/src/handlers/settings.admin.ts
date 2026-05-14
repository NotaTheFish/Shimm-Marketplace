import type { Bot } from "grammy";

export function registerSettingsAdmin(bot: Bot) {
  bot.command("settings", async (c) => {
    await c.reply("settings: заглушка (Блок 21).");
  });
}
