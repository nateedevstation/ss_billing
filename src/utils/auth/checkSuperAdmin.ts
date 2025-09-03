import { FastifyReply, FastifyRequest } from "fastify";
import { AdministerRequestBody } from "../../types/auth";


export default async (request: FastifyRequest<{
  Body: AdministerRequestBody
}>, reply: FastifyReply ) => {
  try {
   if (request.body.username == "test"){
    return reply.send("what")
    }
  } catch (error) {
    reply.status(500).send({
      error,
    })  
  }
}