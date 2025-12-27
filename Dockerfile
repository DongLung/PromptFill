# Build stage using UBI 9 minimal with Node.js 20
FROM registry.access.redhat.com/ubi9/nodejs-20-minimal:latest AS builder

WORKDIR /app

# Copy package files first for better layer caching
COPY package*.json ./

# Install dependencies
# Note: strict-ssl is disabled for sandboxed build environments
# In production, remove this line or configure proper SSL certificates
RUN npm config set strict-ssl false && \
    npm ci && \
    npm cache clean --force

# Copy application source
COPY . .

# Build the application
RUN npm run build

# Runtime stage using UBI 9 minimal with Node.js 20
FROM registry.access.redhat.com/ubi9/nodejs-20-minimal:latest

WORKDIR /app

# Install serve globally for serving static files
# Note: strict-ssl is disabled for sandboxed build environments
# In production, remove this line or configure proper SSL certificates
RUN npm config set strict-ssl false && \
    npm install -g serve && \
    npm cache clean --force

# Copy built assets from builder
COPY --from=builder /app/dist ./dist

# Switch to non-root user (default user in UBI nodejs image)
USER 1001

EXPOSE 3000

# Serve the static files
CMD ["serve", "-s", "dist", "-l", "3000"]
