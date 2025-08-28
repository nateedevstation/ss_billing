# ---------- deps
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

# ---------- build (TypeScript -> dist, generate Prisma client)
FROM node:20-alpine AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . ./
# Generate Prisma Client (output: ss_server/src/generated/prisma)
RUN npx prisma generate
# Build your Fastify server (expects "build": "tsc" in package.json)
RUN npm run build

# ---------- runtime
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# deps
COPY --from=deps /app/node_modules ./node_modules
# compiled server
COPY --from=build /app/dist ./dist
# prisma schema + migrations
COPY --from=build /app/prisma ./prisma
# generated prisma client (because your schema outputs to ../src/generated/prisma)
COPY --from=build /app/src/generated ./src/generated
# package files (for "npm run" in case you use it)
COPY package*.json ./

EXPOSE 3001
# Apply migrations, then start server
CMD sh -c "npx prisma migrate deploy && node dist/server.js"