import {  FastifyReply, FastifyRequest } from "fastify";
import { randomBytes, scryptSync } from "crypto";

export async function signupController (request: FastifyRequest, reply: FastifyReply) {
  try {
    const prisma = request.server.prisma;
    const { email, password, name } = request.body as { email: string; password: string; name?: string };

    if (!email || !password) {
      return reply.status(400).send({ error: "Email and password are required" });
    }

    const salt = randomBytes(16).toString("hex");
    const hash = scryptSync(password, salt, 64).toString("hex");
    const hashedPassword = `${salt}:${hash}`;

    await prisma.administrater.create({
      data: {
        username: email,
        password: hashedPassword,
        first_name: name ?? null,
      },
    });

    return reply.status(201).send({ message: "User created successfully" });
  } catch (error) {
    console.error("Signup error:", error);
    return reply.status(500).send({ error: "Internal server error" });
  }
}
