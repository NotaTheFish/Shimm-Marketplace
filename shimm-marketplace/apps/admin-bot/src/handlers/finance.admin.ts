import type { Bot } from "grammy";

export function registerFinanceAdmin(bot: Bot) {
  bot.command("finance", async (c) => {
    await c.reply("finance: заглушка (Блок 21).");
  });
}
