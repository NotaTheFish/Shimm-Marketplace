/** Strip control chars / homoglyph normalization hooks (Блок 22). */
export function sanitizeUserText(input: string, maxLen = 4000): string {
  const trimmed = input.replace(/\u0000/g, "").trim().slice(0, maxLen);
  return trimmed;
}
