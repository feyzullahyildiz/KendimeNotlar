# Keycloak

### nasıl kaldırırım
- cd docker
- docker compose up


### Nginx arkasında çalıştırma
- nginx
```conf
server {
        server_name example.com;

        location / {
                proxy_pass http://127.0.0.1:8080/;
        }

    listen [::]:80;
    listen 80;
}
```
- docker run --rm --name mykeycloak -p 8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=change_me quay.io/keycloak/keycloak:latest start-dev --hostname=https://example.com

