FROM node:20-slim

WORKDIR /app

# Install build dependencies for native modules (better-sqlite3)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 make g++ && rm -rf /var/lib/apt/lists/*

# Copy package files and install
COPY package.json package-lock.json ./
COPY packages/ ./packages/
COPY apps/ ./apps/
RUN npm ci --ignore-scripts && npm rebuild better-sqlite3

# Copy source
COPY . .

# Build frontend
RUN npm run build || true

# Cloud Run sets PORT=8080
ENV PORT=8080
EXPOSE 8080

CMD ["npx", "tsx", "server/index.ts"]
