/** RBAC matrix — expand per Блок 21. */
export type AdminCapability = "users.read" | "deals.read" | "emergency.write";

export function hasCapability(_adminId: string, _cap: AdminCapability): boolean {
  return false;
}
