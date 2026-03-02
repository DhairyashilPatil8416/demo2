# -------- Stage 1: Build React App --------
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies (faster for CI/CD)
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build production app
RUN npm run build


# -------- Stage 2: Serve with Nginx --------
FROM nginx:alpine

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from builder
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]