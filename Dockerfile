# Stage 1: Dependencies
# Using a specific version of node with alpine for smaller size
FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Stage 2: Builder
# Use the same base image for consistency
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Build the Next.js application
RUN yarn build

# Stage 3: Runner
FROM node:18-alpine AS runner
WORKDIR /app

# Ensuring files are owned by non-root user
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Create and use a non-root user for security purposes
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001 -G nodejs
USER nextjs

# Set non-root user and expose port 3006 for the application
EXPOSE 3000
ENV PORT 3000

CMD ["yarn", "start"]
