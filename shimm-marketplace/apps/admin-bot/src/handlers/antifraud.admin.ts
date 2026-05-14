import type { Bot } from "grammy";

export function registerAntifraudAdmin(bot: Bot) {
  bot.command("antifraud", async (c) => {
    await c.reply("antifraud: заглушка (Блок 21).");
  });
}
