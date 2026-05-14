import type { FastifyInstance } from "fastify";
import type { Logger } from "@shimm/logger";
import Fastify from "fastify";
import { Prisma } from "@prisma/client";
import { loadConfig, type AppConfig } from "@shimm/config";
import { getPrisma } from "@shimm/database";
import { createLogger } from "@shimm/logger";
import type { BotKind } from "@shimm/shared-types";

function isUniqueViolation(err: unknown): boolean {
  return err instanceof Prisma.PrismaClientKnownRequestError && err.code === "P2002";
}

async function registerTelegramWebhook(
  app: FastifyInstance,
  path: string,
  botKind: BotKind,
  secret: string | undefined,
) {
  app.post(path, async (req, reply) => {
    const token = req.headers["x-telegram-bot-api-secret-token"];
    if (secret && token !== secret) {
      return reply.code(401).send({ ok: false, error: "invalid_secret" });
    }
    const body = req.body as { update_id?: number };
    if (body?.update_id == null) {
      return reply.code(400).send({ ok: false, error: "missing_update_id" });
    }
    const prisma = getPrisma();
    try {
      await prisma.processedTelegramUpdate.create({
        data: {
          botKind,
          updateId: BigInt(body.update_id),
        },
      });
    } catch (err) {
      if (!isUniqueViolation(err)) throw err;
    }
    return reply.send({ ok: true, queued: true });
  });
}

export async function buildApp(): Promise<{
  app: FastifyInstance;
  config: AppConfig;
  log: Logger;
}> {
  const config = loadConfig();
  const log = createLogger("api", config.LOG_LEVEL);
  const app = Fastify({ logger: false });

  app.get("/health", async () => ({ status: "ok", app: config.APP_NAME }));

  app.get("/ready", async (_, reply) => {
    try {
      await getPrisma().$queryRaw`SELECT 1`;
      return { ready: true };
    } catch {
      return reply.code(503).send({ ready: false });
    }
  });

  await registerTelegramWebhook(app, "/webhook/client", "client", config.CLIENT_BOT_WEBHOOK_SECRET);
  await registerTelegramWebhook(app, "/webhook/admin", "admin", config.ADMIN_BOT_WEBHOOK_SECRET);
  await registerTelegramWebhook(app, "/webhook/deal", "deal", config.DEAL_BOT_WEBHOOK_SECRET);

  app.addHook("onClose", async () => {
    await getPrisma().$disconnect().catch(() => undefined);
    log.info("api_closed");
  });

  return { app, config, log };
}
