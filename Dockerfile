FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000 8080
RUN npm run build
CMD npm run api

# production stage
FROM nginx:stable as production-stage
RUN apt-get update -y && apt-get install -y apache2-utils && rm -rf /var/lib/apt/lists/*
ENV BASIC_USERNAME=Hasher
ENV BASIC_PASSWORD="L#(qc{f}TaJu4%4k"
COPY --from=build-stage /app/dist/* /var/www
RUN rm /etc/nginx/conf.d/default.conf
RUN htpasswd -c -b /etc/nginx/.htpasswd $BASIC_USERNAME $BASIC_PASSWORD 
CMD nginx -g "daemon off;"
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
