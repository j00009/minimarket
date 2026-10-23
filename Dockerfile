
FROM node:22-bookworm-slim AS base

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable \
    && corepack prepare pnpm@9.15.9 --activate

FROM base AS builder

ENV DATABASE_URL=postgresql://app:secret@localhost:5432/minimarket

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/api/package.json ./apps/api/package.json
COPY apps/web/package.json ./apps/web/package.json
COPY apps/api/prisma.config.ts ./apps/api/prisma.config.ts
COPY apps/api/prisma ./apps/api/prisma

RUN pnpm install --filter api... --frozen-lockfile

COPY . .

RUN pnpm --filter api exec prisma generate \
    && node -e "const fs=require('fs');const path=require('path');const client=fs.realpathSync('/app/apps/api/node_modules/@prisma/client');const generated=path.join(path.dirname(path.dirname(client)),'.prisma/client');fs.mkdirSync('/app/apps/api/node_modules/.prisma',{recursive:true});fs.cpSync(generated,'/app/apps/api/node_modules/.prisma/client',{recursive:true});" \
    && pnpm --filter api run build

FROM base AS prod-deps

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/api/package.json ./apps/api/package.json
COPY apps/web/package.json ./apps/web/package.json

RUN pnpm install --filter api... --prod --frozen-lockfile
RUN pnpm --filter api deploy --prod /prod/api
RUN node -e "const fs=require('fs');const path=require('path');const modules='/prod/api/node_modules';const virtualStore=path.join(modules,'.pnpm');const target=fs.readdirSync(virtualStore).find(name=>name.startsWith('@prisma+client@7.8.0_'));if(!target)throw new Error('Prisma Client 7.8.0 missing from deployed production dependencies');const link=path.join(modules,'@prisma/client');fs.rmSync(link,{recursive:true,force:true});fs.symlinkSync(path.join('..','.pnpm',target,'node_modules/@prisma/client'),link,'dir');"

FROM node:22-bookworm-slim AS runner

WORKDIR /app

ENV NODE_ENV=production

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=prod-deps --chown=node:node /prod/api/node_modules ./apps/api/node_modules
COPY --from=builder --chown=node:node /app/apps/api/node_modules/.prisma ./apps/api/node_modules/.prisma
RUN node -e "const fs=require('fs');const path=require('path');const client=fs.realpathSync('/app/apps/api/node_modules/@prisma/client');const generated='/app/apps/api/node_modules/.prisma/client';const destination=path.join(path.dirname(path.dirname(client)),'.prisma/client');fs.mkdirSync(path.dirname(destination),{recursive:true});fs.cpSync(generated,destination,{recursive:true});"
COPY --from=builder --chown=node:node /app/apps/api/dist ./apps/api/dist
COPY --from=builder --chown=node:node /app/apps/api/package.json ./apps/api/package.json
COPY --from=builder --chown=node:node /app/apps/api/prisma.config.ts ./apps/api/prisma.config.ts
COPY --from=builder --chown=node:node /app/apps/api/prisma ./apps/api/prisma
USER node

EXPOSE 3000

CMD ["node", "apps/api/dist/src/main.js"]
