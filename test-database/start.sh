#!/bin/sh

# Run the MySQL container, with a database named 'users' and credentials
# for a users-service user which can access it.
echo "Starting DB Container..."
docker run --name db --detach \
    --env MYSQL_ROOT_PASSWORD=123 \
    --env MYSQL_DATABASE=users \
    --env MYSQL_USER=users_service \
    --env MYSQL_PASSWORD=123 \
    --publish 3307:3306 \
    mysql:latest

# Wait for the database service to start up.
echo "Waiting for the DB to start up..."
docker exec db mysqladmin --silent --wait=30 --user=users_service --password=123 ping || exit 1

# Run the setup script.
echo "Setting up initial data..."
docker exec --interactive db mysql --user=users_service --password=123 users < setup.sql

