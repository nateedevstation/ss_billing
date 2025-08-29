// src/plugins/auth.ts
import fp from "fastify-plugin";
import jwt from "@fastify/jwt";
import cookie from "@fastify/cookie";

export default fp(async (app) => {
  await app.register(cookie, { hook: "onRequest" });
  await app.register(jwt, {
    secret: process.env.JWT_ACCESS_SECRET!,
  });

  // decorator: require access token
  app.decorate("auth", async (req: any) => {
    const auth = req.headers.authorization;
    if (!auth?.startsWith("Bearer ")) {
      throw app.httpErrors.unauthorized();
    }
    try {
      req.user = await req.jwtVerify();
    } catch {
      throw app.httpErrors.unauthorized();
    }
  });
});

declare module "fastify" {
  interface FastifyInstance {
    auth: (req: any) => Promise<void>;
  }
}