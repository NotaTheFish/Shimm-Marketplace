import { randomBytes } from "node:crypto";

export function createNonce(bytes = 16): string {
  return randomBytes(bytes).toString("hex");
}
