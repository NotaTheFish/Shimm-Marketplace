import { getPrisma } from "../prisma.service.js";

export class ReviewRepo {
  listForTarget(targetId: string, take = 20) {
    return getPrisma().review.findMany({ where: { targetId }, take, orderBy: { createdAt: "desc" } });
  }
}
