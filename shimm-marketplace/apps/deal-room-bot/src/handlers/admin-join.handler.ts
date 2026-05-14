import type { Bot } from "grammy";

export function registerAdminJoin(bot: Bot) {
  bot.command("admin_join", async (c) => {
    await c.reply("Вход администратора по инвайту: Блок 1.");
  });
}
