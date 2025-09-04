

import { PrismaClient, adminRole } from "../../generated/prisma";
import { randomBytes, scryptSync, timingSafeEqual } from "crypto";

// Password utilities
export function hashPassword(password: string): string {
  const salt = randomBytes(16).toString("hex");
  const hash = scryptSync(password, salt, 64).toString("hex");
  return `${salt}:${hash}`;
}

export function verifyPassword(password: string, stored: string): boolean {
  const [salt, storedHashHex] = stored.split(":");
  if (!salt || !storedHashHex) return false;
  const computed = scryptSync(password, salt, 64);
  const saved = Buffer.from(storedHashHex, "hex");
  return saved.length === computed.length && timingSafeEqual(saved, computed);
}

// Data access
export async function findAdminByEmail(prisma: PrismaClient, email: string) {
  return prisma.administrater.findUnique({
    where: { username: email },
  });
}

export async function createAdmin(
  prisma: PrismaClient,
  params: { email: string; password: string; first_name?: string | null; last_name?: string | null; role?: adminRole }
) {
  const { email, password, first_name = null, last_name = null, role } = params;
  return prisma.administrater.create({
    data: {
      username: email,
      password,
      first_name,
      last_name,
      ...(role ? { role } : {}),
    },
  });
}
