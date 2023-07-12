FROM node:20.3.1

WORKDIR /home/node/app

COPY package*.json ./

COPY prisma ./prisma/

# COPY
COPY ./build ./build

RUN npm i --production

RUN npm i -g prisma

RUN npx prisma generate

EXPOSE 3000
