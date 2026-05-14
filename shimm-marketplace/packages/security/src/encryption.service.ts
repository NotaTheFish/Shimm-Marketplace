/** Field-level encryption stub — use KMS + ENCRYPTION_KEY in production. */
export function encryptField(_plain: string): string {
  throw new Error("encryptField not configured");
}

export function decryptField(_cipher: string): string {
  throw new Error("decryptField not configured");
}
