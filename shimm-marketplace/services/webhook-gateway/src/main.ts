import Fastify from "fastify";

/** Edge ingress (nginx TLS) может проксировать сюда; основные webhook — в `apps/api`. */
async function main() {
  const app = Fastify({ logger: true });
  app.get("/health", async () => ({ ok: true, service: "webhook-gateway" }));
  const port = Number(process.env.WEBHOOK_GATEWAY_PORT ?? 8020);
  await app.listen({ port, host: "0.0.0.0" });
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
