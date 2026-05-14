import { DealState } from "@shimm/database";

/** Разрешённые переходы — расширять до полной матрицы Блока 1. */
const ALLOWED: Partial<Record<DealState, DealState[]>> = {
  [DealState.created]: [DealState.pending_seller_review, DealState.archived],
  [DealState.pending_seller_review]: [
    DealState.seller_accepted,
    DealState.seller_declined,
    DealState.archived,
  ],
  [DealState.seller_accepted]: [DealState.secret_chat_created],
  [DealState.secret_chat_created]: [DealState.waiting_participants_join],
  [DealState.waiting_participants_join]: [DealState.active, DealState.archived],
  [DealState.active]: [
    DealState.guarantor_requested,
    DealState.completion_requested,
    DealState.scam_reported,
    DealState.disputed,
    DealState.archived,
  ],
  [DealState.completion_requested]: [
    DealState.completion_confirmed_by_client,
    DealState.completion_confirmed_partial,
    DealState.disputed,
  ],
  [DealState.completion_confirmed_by_client]: [
    DealState.completion_confirmed_partial,
    DealState.completion_confirmed_full,
  ],
  [DealState.completion_confirmed_partial]: [
    DealState.completion_confirmed_full,
    DealState.feedback_phase,
  ],
  [DealState.completion_confirmed_full]: [DealState.feedback_phase, DealState.close_requested],
  [DealState.feedback_phase]: [DealState.close_requested, DealState.closed],
  [DealState.close_requested]: [DealState.closed, DealState.force_closed],
  [DealState.closed]: [DealState.archived],
  [DealState.force_closed]: [DealState.archived],
};

export function isTransitionAllowed(from: DealState, to: DealState): boolean {
  if (from === to) return true;
  const next = ALLOWED[from];
  return next?.includes(to) ?? false;
}
