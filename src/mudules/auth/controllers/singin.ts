import { FastifyReply, FastifyRequest } from "fastify";
import { scryptSync, timingSafeEqual } from "crypto";

export async function signinController(request: FastifyRequest, reply: FastifyReply) {
  try {
    const prisma = request.server.prisma;
    const { email, password } = request.body as { email: string; password: string };

    if (!email || !password) {
      return reply.status(400).send({ error: "Email and password are required" });
    }
    
    const user = await prisma.administrater.findUnique({
      where: { username: email },
      select: { id: true, username: true, password: true, role: true },
    });


    if (!user) {
      return reply.status(401).send({ error: "Invalid credentials" });
    }
    
    const [salt, storedHashHex] = user.password.split(":");
    if (!salt || !storedHashHex) {
      return reply.status(401).send({ error: "Invalid credentials" });
    }

    const computed = scryptSync(password, salt, 64);
    const stored = Buffer.from(storedHashHex, "hex");

    const ok = stored.length === computed.length && timingSafeEqual(stored, computed);
    if (!ok) {
      return reply.status(401).send({ error: "Invalid credentials" });
    }

    const token = await reply.jwtSign({ sub: user.id, username: user.username, role: user.role });
    return reply.status(200).send({ token });
  } catch (error) {
    request.server.log.error({ err: error }, "Signin error");
    return reply.status(500).send({ error: "Internal server error" });
  }
}
