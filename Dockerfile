FROM node:16-alpine AS deps

ENV NODE_ENV=production

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

FROM node:16-alpine AS builder

ENV NODE_ENV=production

WORKDIR /app

COPY next.config.js ./
COPY package.json yarn.lock ./
COPY --from=deps /app/node_modules ./node_modules

COPY pages ./pages
COPY public ./public
COPY styles ./styles
COPY lib ./lib
COPY components ./components
COPY .env .env
COPY .env.local .env.local

RUN yarn build

FROM node:16-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/.env .env
COPY --from=builder --chown=nextjs:nodejs /app/.env.local .env.local

USER nextjs

CMD ["node", "server.js"]