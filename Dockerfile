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

# Copying the nginx configuration template into the container
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Copying the built Angular app to the Nginx serve directory
COPY --from=build /app/dist/hello-docker /usr/share/nginx/html

# Using envsubst to replace the PORT variable and running Nginx in the foreground
CMD /bin/sh -c "envsubst < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
