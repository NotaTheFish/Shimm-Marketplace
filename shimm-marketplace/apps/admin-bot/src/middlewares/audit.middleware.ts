import type { Context, NextFunction } from "grammy";
import { createLogger } from "@shimm/logger";

const log = createLogger("admin-audit");

export function auditMiddleware() {
  return async (ctx: Context, next: NextFunction) => {
    const start = Date.now();
    await next();
    log.info(
      {
        updateId: ctx.update.update_id,
        from: ctx.from?.id,
        ms: Date.now() - start,
      },
      "admin_update",
    );
  };
}
