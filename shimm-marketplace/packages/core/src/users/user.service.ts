import type { User } from "@shimm/database";
import { UserRepo } from "@shimm/database";
import type { Logger } from "pino";

export type TelegramUserPayload = {
  telegramUserId: bigint;
  username?: string | null;
  firstName?: string | null;
  lastName?: string | null;
  languageCode?: string | null;
};

export class UserService {
  constructor(
    private readonly repo: UserRepo,
    private readonly log: Logger,
  ) {}

  async ensureFromTelegram(payload: TelegramUserPayload): Promise<User> {
    const user = await this.repo.upsertFromTelegram(payload);
    this.log.info({ userId: user.id }, "user_upserted");
    return user;
  }
}
