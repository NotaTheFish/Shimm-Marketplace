import type { Bot } from "grammy";

export function registerDisputesAdmin(bot: Bot) {
  bot.command("disputes", async (c) => {
    await c.reply("disputes: заглушка (Блок 21).");
  });
}
