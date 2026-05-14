import type { Bot } from "grammy";

export function registerClose(bot: Bot) {
  bot.command("close", async (c) => {
    await c.reply("Закрытие чата: Блок 1.");
  });
}
