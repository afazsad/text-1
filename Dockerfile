root@ubuntu-s-1vcpu-1gb-amd-fra1-01:/var/www/text-1#   docker-compose up -d --build
Building nextjs
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  88.58kB
Step 1/16 : FROM node:18-alpine AS builder
 ---> ee77c6cd7c18
Step 2/16 : WORKDIR /app
 ---> Using cache
 ---> 6aff2018cf95
Step 3/16 : COPY package*.json ./
 ---> Using cache
 ---> f163a6adf7ae
Step 4/16 : RUN npm install
 ---> Using cache
 ---> 19e4f0820462
Step 5/16 : COPY . .
 ---> Using cache
 ---> b14efc2efa37
Step 6/16 : RUN npm run build
 ---> Using cache
 ---> dbb4fb950ed8
Step 7/16 : RUN apt-get update && apt-get install -y curl
 ---> Running in 511ce61a9e64
/bin/sh: apt-get: not found
The command '/bin/sh -c apt-get update && apt-get install -y curl' returned a non-zero code: 127
ERROR: Service 'nextjs' failed to build : Build failed
root@ubuntu-s-1vcpu-1gb-amd-fra1-01:/var/www/text-1#



# مرحله build
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

RUN apt-get update && apt-get install -y curl

# مرحله production
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]
