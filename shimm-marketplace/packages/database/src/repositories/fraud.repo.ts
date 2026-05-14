import { getPrisma } from "../prisma.service.js";

export class FraudRepo {
  listOpenForDeal(dealId: string) {
    return getPrisma().fraudReport.findMany({ where: { dealId, status: "open" } });
  }
}
