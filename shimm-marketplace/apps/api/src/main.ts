import { buildApp } from "./app.js";

async function main() {
  const { app, config, log } = await buildApp();
  const port = config.API_PORT;
  await app.listen({ port, host: "0.0.0.0" });
  log.info({ port }, "api_listening");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
