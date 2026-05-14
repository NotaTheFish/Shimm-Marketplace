import pino from "pino";

export type Logger = pino.Logger;

export function createLogger(name: string, level: string = "info") {
  return pino({
    name,
    level,
    base: { service: name },
  });
}
