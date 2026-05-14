import { AsyncLocalStorage } from "node:async_hooks";

export type AuditContext = { adminId?: string; ip?: string; requestId?: string };

const storage = new AsyncLocalStorage<AuditContext>();

export function runWithAuditContext<T>(ctx: AuditContext, fn: () => T): T {
  return storage.run(ctx, fn);
}

export function getAuditContext(): AuditContext | undefined {
  return storage.getStore();
}
