import type { Bot } from "grammy";

export function registerRules(bot: Bot) {
  bot.command("rules", async (c) => {
    await c.reply("Правила сделки (закреп): Блок 1, доп. 5.");
  });
}
