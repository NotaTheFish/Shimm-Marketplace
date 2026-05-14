import type { Context, NextFunction } from "grammy";

/** RBAC: расширять через @shimm/permissions + AdminUser в БД. */
export function rbacMiddleware() {
  return async (_ctx: Context, next: NextFunction) => {
    await next();
  };
}
