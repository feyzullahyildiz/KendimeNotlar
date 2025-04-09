# Keycloak

### Docker Network Oluşturma
```bash
docker network create keycloak-network
```

### PostgreSQL Database Setup
```bash
docker run --name keycloak-postgres \
  -e POSTGRES_DB=keycloak \
  -e POSTGRES_USER=keycloak \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  --network keycloak-network \
  -d postgres:16
```

### Keycloak with PostgreSQL (Production)
```bash
docker run --name mykeycloak -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=change_me \
  --network keycloak-network \
  quay.io/keycloak/keycloak:latest \
  start \
  --db=postgres --features=token-exchange \
  --db-url=jdbc:postgresql://keycloak-postgres:5432/keycloak \
  --db-username=keycloak --db-password=password \
  --hostname=https://example.com \
  --http-enabled=true
```

### Keycloak with PostgreSQL (Development Mode)
```bash
docker run --name mykeycloak -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=change_me \
  --network keycloak-network \
  quay.io/keycloak/keycloak:latest \
  start-dev \
  --db=postgres --features=token-exchange \
  --db-url=jdbc:postgresql://keycloak-postgres:5432/keycloak \
  --db-username=keycloak --db-password=password \
  --hostname=https://example.com
```

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

### Nginx ile HTTPS (Certbot) Yapılandırması
```conf
server {
    server_name your-domain.com;
    
    location / {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $host;
    }

    listen [::]:443 ssl;
    listen 443 ssl;
    # SSL sertifikaları Certbot tarafından otomatik eklenecek
}
```

```bash
# Certbot kurulumu ve sertifika alımı
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

