import { getPrisma } from "../prisma.service.js";

export class WalletRepo {
  findByUserId(userId: string, currency = "SHIMM") {
    return getPrisma().wallet.findUnique({
      where: { userId_currency: { userId, currency } },
    });
  }
}
