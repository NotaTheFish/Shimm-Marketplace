/** Idempotency store — back with Redis + DB per ТЗ. */
const memory = new Map<string, true>();

export function idempotencySeen(key: string): boolean {
  return memory.has(key);
}

export function idempotencyMark(key: string): void {
  memory.set(key, true);
}
