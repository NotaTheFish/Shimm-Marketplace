import type { DealState } from "@shimm/database";
import { isTransitionAllowed } from "./deal.transitions.js";

export function assertDealTransition(from: DealState, to: DealState): void {
  if (!isTransitionAllowed(from, to)) {
    throw new Error(`Illegal deal transition ${from} -> ${to}`);
  }
}
