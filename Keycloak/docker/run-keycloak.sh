docker run --name mykeycloak -p 8080:8080 \
        -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=change_me \
        quay.io/keycloak/keycloak:latest \
        start \
        --db=postgres --features=token-exchange \
        --db-url=<JDBC-URL> --db-username=<DB-USER> --db-password=<DB-PASSWORD> \
        --https-key-store-file=<file> --https-key-store-password=<password>