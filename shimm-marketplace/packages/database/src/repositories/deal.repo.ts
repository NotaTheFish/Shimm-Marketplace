import { getPrisma } from "../prisma.service.js";

export class DealRepo {
  findById(id: string) {
    return getPrisma().deal.findUnique({ where: { id } });
  }
}
