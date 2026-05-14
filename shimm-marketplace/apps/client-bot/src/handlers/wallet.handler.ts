import type { Bot } from "grammy";

export function registerWallet(bot: Bot) {
  bot.command("wallet", async (ctx) => {
    await ctx.reply("Кошелёк: только через ledger (Блок 4).");
  });
}
