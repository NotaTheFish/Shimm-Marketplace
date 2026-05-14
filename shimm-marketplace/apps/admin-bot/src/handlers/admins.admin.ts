import type { Bot } from "grammy";

export function registerAdminsAdmin(bot: Bot) {
  bot.command("admins", async (c) => {
    await c.reply("admins: заглушка (Блок 21).");
  });
}
