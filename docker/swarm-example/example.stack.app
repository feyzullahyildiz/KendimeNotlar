version: "3"

services:
  nginx:
    image: nginx:alpine
    deploy:
      replicas: 6
    ports:
      - 6060:80
    