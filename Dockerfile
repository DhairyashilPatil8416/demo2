# -------- Stage 1: Build React App --------
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

# Use npm install instead of npm ci
RUN npm install

COPY . .

RUN npm run build


# -------- Stage 2: Serve with Nginx --------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]