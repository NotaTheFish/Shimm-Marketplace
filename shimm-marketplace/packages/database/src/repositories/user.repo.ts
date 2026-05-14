import type { Prisma, User } from "@prisma/client";
import { getPrisma } from "../prisma.service.js";

export class UserRepo {
  async findByTelegramId(telegramUserId: bigint): Promise<User | null> {
    return getPrisma().user.findUnique({ where: { telegramUserId } });
  }

  async upsertFromTelegram(data: {
    telegramUserId: bigint;
    username?: string | null;
    firstName?: string | null;
    lastName?: string | null;
    languageCode?: string | null;
  }): Promise<User> {
    const prisma = getPrisma();
    return prisma.user.upsert({
      where: { telegramUserId: data.telegramUserId },
      create: {
        telegramUserId: data.telegramUserId,
        username: data.username ?? undefined,
        firstName: data.firstName ?? undefined,
        lastName: data.lastName ?? undefined,
        languageCode: data.languageCode ?? undefined,
      },
      update: {
        username: data.username ?? undefined,
        firstName: data.firstName ?? undefined,
        lastName: data.lastName ?? undefined,
        languageCode: data.languageCode ?? undefined,
        lastSeenAt: new Date(),
      },
    });
  }

  async updateFlags(userId: string, patch: Prisma.UserUpdateInput): Promise<User> {
    return getPrisma().user.update({ where: { id: userId }, data: patch });
  }
}
