import {  FastifyReply, FastifyRequest } from "fastify";
import { randomBytes, scryptSync } from "crypto";

export async function signupController (request: FastifyRequest, reply: FastifyReply) {
  try {
    const prisma = request.server.prisma;
    const body = request.body;
    return reply.send({
      msg: "great ",
      body,
    });
  } catch (error) {
    console.error("Signup error:", error);
    return reply.status(500).send({ error: "Internal server error" });
  }
}