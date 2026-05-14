import { loadConfig } from "@shimm/config";
import { createDealRoomBot } from "./deal-room-bot.js";

async function main() {
  const config = loadConfig();
  const token = config.DEAL_ROOM_BOT_TOKEN;
  if (!token) throw new Error("DEAL_ROOM_BOT_TOKEN is required");
  const { bot, log } = createDealRoomBot(token);
  await bot.start();
  log.info("deal_room_bot_started");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
