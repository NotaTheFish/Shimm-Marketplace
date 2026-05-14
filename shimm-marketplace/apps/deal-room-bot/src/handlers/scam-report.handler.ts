import type { Bot } from "grammy";

export function registerScamReport(bot: Bot) {
  bot.command("scam", async (c) => {
    await c.reply("Жалоба на мошенничество: Блок 13.");
  });
}
