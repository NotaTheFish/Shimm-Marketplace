import type { Bot } from "grammy";
import type { Logger } from "@shimm/logger";
import { createGrammyBot } from "@shimm/telegram";
import { createLogger } from "@shimm/logger";
import { UserService } from "@shimm/core";
import { UserRepo } from "@shimm/database";
import { registerStart } from "./handlers/start.handler.js";
import { registerProfile } from "./handlers/profile.handler.js";
import { registerMarket } from "./handlers/market.handler.js";
import { registerDeals } from "./handlers/deals.handler.js";
import { registerWallet } from "./handlers/wallet.handler.js";
import { registerReviews } from "./handlers/reviews.handler.js";
import { registerSupport } from "./handlers/support.handler.js";
import { registerSettings } from "./handlers/settings.handler.js";
import { registerOnboarding } from "./handlers/onboarding.handler.js";

export function createClientBot(token: string): { bot: Bot; log: Logger } {
  const bot = createGrammyBot(token);
  const log = createLogger("client-bot");
  const users = new UserService(new UserRepo(), log);

  registerStart(bot, users);
  registerProfile(bot);
  registerMarket(bot);
  registerDeals(bot);
  registerWallet(bot);
  registerReviews(bot);
  registerSupport(bot);
  registerSettings(bot);
  registerOnboarding(bot);

  return { bot, log };
}
