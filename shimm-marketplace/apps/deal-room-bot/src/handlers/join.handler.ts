import type { Bot } from "grammy";

export function registerJoin(bot: Bot) {
  bot.command("join", async (c) => {
    await c.reply("join: проверка инвайта и роли (Блок 1, доп. 3).");
  });
}
