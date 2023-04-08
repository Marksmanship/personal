# Stage 1
FROM node:latest as build-stage
WORKDIR /app
RUN npm install puppeteer
COPY ./nginx.conf /nginx.conf

# Stage 2
WORKDIR /app
COPY package*.json /app/
RUN npm install 
COPY ./ /app/
ARG configuration=production # formerly 'production'
RUN npm run build -- --output-path=./dist/out --configuration $configuration

# Stage 3
# COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf
FROM nginx:1.15
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf 
