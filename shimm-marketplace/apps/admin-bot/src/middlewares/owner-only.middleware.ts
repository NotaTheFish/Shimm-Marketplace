import type { Context, NextFunction } from "grammy";
import { parseOwnerTelegramIds } from "@shimm/config";

export function ownerOnlyMiddleware(ownerIdsCsv: string | undefined) {
  const owners = new Set(parseOwnerTelegramIds(ownerIdsCsv).map((id: bigint) => id.toString()));
  return async (ctx: Context, next: NextFunction) => {
    const id = ctx.from?.id;
    if (id == null || !owners.has(String(id))) {
      await ctx.reply("Доступ запрещён (только OWNER_TELEGRAM_IDS).");
      return;
    }
    await next();
  };
}
