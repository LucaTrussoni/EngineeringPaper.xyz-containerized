# --- Build stage ---
FROM node:20-slim AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# --- Runtime stage ---
FROM nginx:alpine

LABEL org.opencontainers.image.title="EngineeringPaper.xyz"
LABEL org.opencontainers.image.description="Containerized deployment of EngineeringPaper.xyz for offline and local use"
LABEL org.opencontainers.image.source="https://github.com/LucaTrussoni/engineeringpaper-containerized"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="mgreminger, containerization by Luca Trussoni"

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/engineeringpaper.conf
COPY --from=builder /app/public /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
