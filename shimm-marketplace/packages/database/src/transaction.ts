import type { Prisma } from "@prisma/client";
import { getPrisma } from "./prisma.service.js";

export async function withTransaction<T>(
  fn: (tx: Prisma.TransactionClient) => Promise<T>,
): Promise<T> {
  const prisma = getPrisma();
  return prisma.$transaction(fn);
}
