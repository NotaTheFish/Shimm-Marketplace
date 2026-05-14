/** Shared Tailwind class merge for Mini App (Tailwind + shadcn per skillet). */
export function cn(...parts: Array<string | undefined | false>): string {
  return parts.filter(Boolean).join(" ");
}
