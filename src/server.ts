// src/app.ts
import Fastify from "fastify";
import cookie from "@fastify/cookie";
import jwt from "@fastify/jwt";
import rateLimit from "@fastify/rate-limit";
import cors from "@fastify/cors";
import { prismaPlugin } from "./plugins/prisma";
import sensible from "@fastify/sensible"


// env config must be defined before use

export async function buildApp() {
  const app = Fastify({ logger: true });

  await app.register(rateLimit, { max: 100, timeWindow: "1 minute" });
  await app.register(sensible)
  await app.register(cors, {
    origin: (origin, cb) => cb(null, true), // ปรับ allow-list ในโปรดักชัน
    credentials: true,
  });
  await app.register(cookie, { hook: "onRequest" });

  await app.register(prismaPlugin);

  // routes
  

  return app;
}