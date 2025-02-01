# Use Node.js for building the Angular app
FROM node:20 AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build --prod

# Use Nginx to serve the Angular app
FROM nginx:latest

# Copy built Angular files to Nginx's default directory
COPY --from=build /app/dist/* /usr/share/nginx/html

# Expose the port Nginx runs on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
