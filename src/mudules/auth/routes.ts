import { FastifyInstance } from "fastify";
import { signupController } from "./controllers/signup";
import { signinController } from "./controllers/singin";
import checkSuperAdmin from "../../utils/auth/checkSuperAdmin";

export async function authRoutes(app: FastifyInstance) {
  app.post(
    "/signup",
    {
      preHandler: checkSuperAdmin,
      schema: {
        body: {
          type: "object",
          properties: {
            username: { type: "string", minLength: 1 },
            password: { type: "string", minLength: 8 },
            first_name: { type: "string" },
            last_name: { type: "string" },
            resident_id: { type: "string" },
          },
          required: ["username", "password"],
          additionalProperties: false,
        },
      },
    },
    signupController
  );
  app.post("/signin", signinController);

  app.get("/", (req, res) => {
    res.send("test");
  });
}
