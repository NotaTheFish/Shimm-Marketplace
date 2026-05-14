import type { Bot } from "grammy";

export function registerLogsAdmin(bot: Bot) {
  bot.command("logs", async (c) => {
    await c.reply("logs: заглушка (Блок 18/21).");
  });
}
