import type { Bot } from "grammy";

async function stub(ctx: { reply: (t: string) => Promise<unknown> }, label: string) {
  await ctx.reply(`${label}: заглушка (Блок 21).`);
}

export function registerUsersAdmin(bot: Bot) {
  bot.command("users", (c) => stub(c, "users"));
}
