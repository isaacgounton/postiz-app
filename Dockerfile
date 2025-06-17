# Production Dockerfile for Postiz
FROM node:20-alpine3.19 AS base

# Install system dependencies
RUN apk add --no-cache g++ make py3-pip supervisor bash caddy netcat-openbsd

# Install pnpm and pm2 globally
RUN npm --no-update-notifier --no-fund --global install pnpm@10.6.1 pm2

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/backend/package.json ./apps/backend/
COPY apps/frontend/package.json ./apps/frontend/
COPY apps/workers/package.json ./apps/workers/
COPY apps/cron/package.json ./apps/cron/
COPY libraries/*/package.json ./libraries/*/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Copy Docker configuration files
COPY var/docker/supervisord.conf /etc/supervisord.conf
COPY var/docker/Caddyfile /app/Caddyfile
COPY var/docker/entrypoint.sh /app/entrypoint.sh
COPY var/docker/supervisord/caddy.conf /etc/supervisor.d/caddy.conf

RUN chmod +x /app/entrypoint.sh

# Build the application
RUN pnpm run build

# Create uploads directory
RUN mkdir -p /uploads

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD nc -z localhost 5000 || exit 1

# Start with PM2
CMD ["pnpm", "run", "pm2"]
