import { loadConfig } from "@shimm/config";
import { createAdminBot } from "./admin-bot.js";

async function main() {
  const config = loadConfig();
  const token = config.ADMIN_BOT_TOKEN;
  if (!token) throw new Error("ADMIN_BOT_TOKEN is required");
  const { bot, log } = createAdminBot(token);
  await bot.start();
  log.info("admin_bot_started");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
