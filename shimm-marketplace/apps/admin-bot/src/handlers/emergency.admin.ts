import type { Bot } from "grammy";

export function registerEmergencyAdmin(bot: Bot) {
  bot.command("emergency", async (c) => {
    await c.reply("emergency: заглушка (Блок 21/31 maintenance).");
  });
}
