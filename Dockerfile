FROM node:16-alpine AS deps

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY next.config.js ./next.config.js

COPY pages ./pages
COPY public ./public
COPY styles ./styles
COPY components ./components
COPY lib ./lib
COPY .env /.env
COPY .env.local /.env.local

RUN yarn build

ENV PORT 80

CMD ["yarn", "start"]