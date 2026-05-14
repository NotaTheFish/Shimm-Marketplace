import { getPrisma } from "../prisma.service.js";

export class NotificationRepo {
  listUnread(userId: string) {
    return getPrisma().notification.findMany({ where: { userId, readAt: null }, take: 50 });
  }
}
