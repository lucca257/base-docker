FROM nginx:alpine
RUN apk add --no-cache bash

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
