import { Bot, webhookCallback } from "grammy";

export function createGrammyBot(token: string) {
  return new Bot(token);
}

export { webhookCallback };
