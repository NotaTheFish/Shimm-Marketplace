import { getPrisma } from "../prisma.service.js";

export class LedgerRepo {
  findJournalByIdempotencyKey(key: string) {
    return getPrisma().ledgerJournal.findUnique({ where: { idempotencyKey: key } });
  }
}
