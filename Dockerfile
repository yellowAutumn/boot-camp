# Build stage: build the React app
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage: serve with NGINX
FROM nginx:alpine
# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*
# Copy built React app to NGINX's public folder
COPY --from=build /app/build /usr/share/nginx/html
# Copy custom nginx config if needed (optional)
# COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]