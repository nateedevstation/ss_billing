import { FastifyReply, FastifyRequest } from "fastify";
import { verifyPassword, findAdminByEmail } from "../services";

export async function signinController(request: FastifyRequest, reply: FastifyReply) {
  try {
    const prisma = request.server.prisma;

  } catch (error) {
    request.server.log.error({ err: error }, "Signin error");
    return reply.status(500).send({ error: "Internal server error" });
  }
}
