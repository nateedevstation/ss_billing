// src/plugins/prisma.ts
import fp from "fastify-plugin";
import { PrismaClient } from "../generated/prisma";

export const prismaPlugin = fp(async (app) => {
  const prisma = new PrismaClient({
    log: process.env.NODE_ENV === "development"
      ? ["query", "error", "warn"]
      : ["error"],
  });

  // connect once when server starts
  await prisma.$connect();

  // decorate Fastify instance → available as app.prisma
  app.decorate("prisma", prisma);

  // disconnect on shutdown
  app.addHook("onClose", async (app) => {
    await app.prisma.$disconnect();
  });
});

// let TS know about `app.prisma`
declare module "fastify" {
  interface FastifyInstance {
    prisma: PrismaClient;
  }
}