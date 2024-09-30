# Base image is Node.js 20 on Alpine Linux, which is lightweight
FROM node:20-alpine AS base

# Create a new stage called 'builder' from the 'base' stage
FROM base AS builder

# Set the working directory inside the container to '/app'
WORKDIR /app

# Copy 'package.json' and 'pnpm-lock.yaml' (used by pnpm) to the container
COPY package.json pnpm-lock.yaml* ./

# Install pnpm globally, then install the dependencies
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Copy the rest of the application code to the container
COPY . .

# Disable Next.js telemetry and set the environment to 'production'
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Optional: Environment variables for secrets can be added using ARG
# ARG SECRET_KEY
# ARG API_KEY

# Build the Next.js application
RUN pnpm run build

# Create a new stage called 'runner' from the 'base' stage
FROM base AS runner

# Set the working directory inside the container to '/app'
WORKDIR /app

# Disable Next.js telemetry and set the environment to 'production'
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# Create a system group 'nodejs' with GID 1001
RUN addgroup --system --gid 1001 nodejs

# Create a system user 'nextjs' with UID 1001
RUN adduser --system --uid 1001 nextjs

# Copy only the public assets from the builder stage
COPY --from=builder /app/public ./public

# Create the '.next' directory and give ownership to the 'nextjs' user
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Copy the built Next.js standalone app and static files, setting proper ownership
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Switch to the 'nextjs' user for better security
USER nextjs

# Expose port 3000 where the app will be served
EXPOSE 3000

# Set the environment variable for the port
ENV PORT=3000

# Start the application by running the 'server.js' file
CMD node server.js
