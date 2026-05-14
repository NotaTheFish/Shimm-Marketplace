import type { Bot } from "grammy";

export function registerGuarantor(bot: Bot) {
  bot.command("guarantor", async (c) => {
    await c.reply("Гарант: Блок 12.");
  });
}
