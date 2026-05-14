import type { Bot } from "grammy";

export function registerCompletion(bot: Bot) {
  bot.command("completion", async (c) => {
    await c.reply("Подтверждение выполнения: Блок 11.");
  });
}
