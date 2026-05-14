const base = import.meta.env.VITE_PUBLIC_API_URL ?? "";
export const apiClient = { baseUrl: base };
