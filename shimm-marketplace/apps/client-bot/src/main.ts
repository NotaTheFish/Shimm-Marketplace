import { loadConfig } from "@shimm/config";
import { createClientBot } from "./bot.js";

async function main() {
  const config = loadConfig();
  const token = config.CLIENT_BOT_TOKEN;
  if (!token) {
    throw new Error("CLIENT_BOT_TOKEN is required for client-bot");
  }
  const { bot, log } = createClientBot(token);
  await bot.start();
  log.info("client_bot_started");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
