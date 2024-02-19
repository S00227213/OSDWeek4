# Using Node.js as the base image for the build stage
FROM node:21-alpine3.18 AS build

# Setting the working directory in the container
WORKDIR /app

# Copying the source code to the container
COPY . .

# Installing dependencies
RUN npm install

# Building the Angular application in production mode
RUN npm run build -- --configuration production

# Starting a new stage from nginx to serve the application
FROM nginx:alpine

COPY --from=build /app/dist/hello-docker /usr/share/nginx/html
# Ensure Nginx runs on the foreground
CMD ["nginx", "-g", "daemon off;"]
