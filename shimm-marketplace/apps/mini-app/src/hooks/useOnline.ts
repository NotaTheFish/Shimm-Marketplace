export function useOnline(): boolean {
  return typeof navigator !== "undefined" ? navigator.onLine : true;
}
