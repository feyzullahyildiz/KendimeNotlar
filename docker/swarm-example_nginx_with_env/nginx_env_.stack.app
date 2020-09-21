version: "3"

services:
  nginx:
    image: nginx:alpine
    deploy:
      replicas: 6
    ports:
      - 6060:80
    volumes: 
      - ./index.html:/usr/share/nginx/html/env_index.html
    command: /bin/sh -c "envsubst < /usr/share/nginx/html/env_index.html > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"
    