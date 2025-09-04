// src/plugins/auth.ts
import fp from "fastify-plugin";
import jwt from "@fastify/jwt";
import cookie from "@fastify/cookie";

export default fp(async (app) => {
  await app.register(cookie, { hook: "onRequest" });
  await app.register(jwt, { secret: process.env.JWT_ACCESS_SECRET! });

  // preHandler สำหรับ route ที่ต้องการ auth
  app.decorate("auth", async (req: any) => {
    const auth = req.headers.authorization;
    if (!auth?.startsWith("Bearer ")) {
      const err: any = new Error("Unauthorized");
      err.statusCode = 401;
      throw err;
    }
    try {
      req.user = await req.jwtVerify();
    } catch {
      const err: any = new Error("Unauthorized");
      err.statusCode = 401;
      throw err;
    }
  });
});

declare module "fastify" {
  interface FastifyInstance {
    auth: (req: any) => Promise<void>;
  }
}