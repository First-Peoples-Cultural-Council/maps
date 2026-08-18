FROM node:13.14.0-buster AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
ENV NODE_ENV=production
RUN yarn run build

FROM node:13.14.0-buster-slim AS runtime

WORKDIR /app
ENV NODE_ENV=production

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production=true && yarn cache clean

COPY --from=builder /app/.nuxt ./.nuxt
COPY --from=builder /app/static ./static
COPY --from=builder /app/server ./server
COPY --from=builder /app/nuxt.config.js ./nuxt.config.js

EXPOSE 80

CMD ["yarn", "run", "start"]
