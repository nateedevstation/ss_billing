import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify";

export async function singupController (request: FastifyRequest, reply: FastifyReply) {
  try {
    const { email, password, name } = request.body as { email: string; password: string; name?: string };

    if (!email || !password) {
      return reply.status(400).send({ error: "Email and password are required" });
    }

    // TODO: Hash password and save user to database
    // Example:
    // const hashedPassword = await hashPassword(password);
    // await userService.createUser({ email, password: hashedPassword, name });

    return reply.status(201).send({ message: "User created successfully" });
  } catch (error) {
    console.error("Signup error:", error);
    return reply.status(500).send({ error: "Internal server error" });
  }
}