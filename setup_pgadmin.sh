#!/bin/sh

# Wait for pgAdmin to start
sleep 10

# Login to pgAdmin
curl -s --request POST \
    --url http://127.0.0.1/login \
    --header 'Content-Type: application/json' \
    --data "{\"email\": \"${PGADMIN_DEFAULT_EMAIL}\", \"password\": \"${PGADMIN_DEFAULT_PASSWORD}\"}"

# Add server configuration to pgAdmin
curl -s --request POST \
    --url http://127.0.0.1/browser/server/group/1/ \
    --header "Content-Type: application/json" \
    --data "{
        \"name\": \"PostgreSQL\",
        \"host\": \"${DB_HOST}\",
        \"port\": ${DB_PORT},
        \"maintenance_db\": \"${DB_NAME}\",
        \"username\": \"${DB_USER}\",
        \"password\": \"${DB_PASSWORD}\",
        \"sslmode\": \"prefer\"
    }"
