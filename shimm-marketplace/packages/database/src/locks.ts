/** Distributed locks — implement with Redis in production (Блок 29 / 31). */
export type LockHandle = { release: () => Promise<void> };

export async function acquireStubLock(_key: string): Promise<LockHandle> {
  return {
    async release() {
      /* no-op stub */
    },
  };
}
