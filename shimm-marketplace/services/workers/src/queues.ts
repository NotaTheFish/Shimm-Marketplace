import { Queue } from "bullmq";
import { Redis } from "ioredis";
import { loadConfig } from "@shimm/config";
import { createLogger } from "@shimm/logger";

export function createQueues(connection: Redis) {
  return {
    telegramSend: new Queue("telegram_send", { connection }),
    notifications: new Queue("notifications", { connection }),
  };
}

export async function registerDefaultWorkers() {
  const config = loadConfig();
  const log = createLogger("workers");
  const url = config.REDIS_URL;
  if (!url) {
    log.warn("REDIS_URL missing — workers idle (Блок 31).");
    return;
  }
  const connection = new Redis(url);
  createQueues(connection);
  log.info("workers_queues_ready");
}
