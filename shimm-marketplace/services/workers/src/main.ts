import { registerDefaultWorkers } from "./queues.js";

async function main() {
  await registerDefaultWorkers();
  console.log("workers service up (queues initialized when REDIS_URL set)");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
