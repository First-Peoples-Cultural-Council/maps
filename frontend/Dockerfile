FROM node:22.18.0-bookworm AS builder

WORKDIR /app

RUN corepack enable && corepack prepare yarn@1.22.22 --activate

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
ENV NODE_ENV=production
RUN yarn run build

FROM node:22.18.0-bookworm-slim AS runtime

WORKDIR /app
ENV NODE_ENV=production

RUN corepack enable && corepack prepare yarn@1.22.22 --activate

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=true && yarn cache clean

COPY --from=builder --chown=node:node /app/.nuxt ./.nuxt
COPY --from=builder --chown=node:node /app/static ./static
COPY --from=builder --chown=node:node /app/server ./server
COPY --from=builder --chown=node:node /app/nuxt.config.js ./nuxt.config.js

EXPOSE 80

USER node

CMD ["yarn", "run", "start"]
