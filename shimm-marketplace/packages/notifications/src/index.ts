export type OutboundNotification = { userId: string; channel: string; payload: unknown };

export async function enqueueNotification(_n: OutboundNotification): Promise<void> {
  /* BullMQ worker (services/workers) */
}
