FROM node:22.23.2-bookworm AS builder

WORKDIR /app

RUN corepack enable && corepack prepare yarn@1.22.22 --activate

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

ARG BACKEND_URL
ENV BACKEND_URL=${BACKEND_URL}
ENV NODE_ENV=production
RUN yarn run build

FROM node:22.23.2-bookworm-slim AS runtime

WORKDIR /app

ARG BACKEND_URL
ENV BACKEND_URL=${BACKEND_URL}
ENV NODE_ENV=production

# TODO: Remove this npm override when the Node base image includes npm with tar >=7.5.19.
RUN npm install --global npm@11.19.1 \
	&& corepack enable \
	&& corepack prepare yarn@1.22.22 --activate

COPY package.json yarn.lock ./
# TODO: Remove this minimist cleanup after upgrading mapbox-gl to >=1.13.0.
RUN yarn install --frozen-lockfile --production=true \
	&& yarn cache clean \
	&& rm -rf node_modules/mapbox-gl/src/style-spec/node_modules/minimist

COPY --from=builder --chown=node:node /app/.nuxt ./.nuxt
COPY --from=builder --chown=node:node /app/static ./static
COPY --from=builder --chown=node:node /app/server ./server
COPY --from=builder --chown=node:node /app/nuxt.config.js ./nuxt.config.js

EXPOSE 80

USER node

CMD ["yarn", "run", "start"]
