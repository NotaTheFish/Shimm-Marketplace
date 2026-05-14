import type { Bot } from "grammy";

export function registerOnboarding(bot: Bot) {
  bot.command("onboarding", async (ctx) => {
    await ctx.reply("Онбординг: в разработке (Блок 30).");
  });
}
