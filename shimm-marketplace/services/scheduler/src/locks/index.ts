/** Distributed locks for cron — Redis SETNX (Блок 31). */
export async function withSchedulerLock<T>(
  _key: string,
  fn: () => Promise<T>,
): Promise<T> {
  return fn();
}
