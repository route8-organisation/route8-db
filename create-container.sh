#!/bin/bash

domain="db.route8.local"
container_name="route8-db"

echo -n "enter the FQDN [$domain]: "
read user_input

if [ "$user_input" != "" ]; then
    domain="$user_input"
fi

echo -n "enter the container name [$container_name]: "
read user_input

if [ "$user_input" != "" ]; then
    container_name="$user_input"
fi

echo "creating the TLS for '$domain'"

openssl req -new -x509 -days 365 -nodes -text -out server.crt \
  -keyout server.key -subj "/CN=$domain"

chmod og-rwx server.key

openssl req -new -nodes -text -out root.csr \
  -keyout root.key -subj "/CN=$domain"
chmod og-rwx root.key

openssl x509 -req -in root.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -signkey root.key -out root.crt

openssl req -new -nodes -text -out server.csr \
  -keyout server.key -subj "/CN=$domain"
chmod og-rwx server.key

openssl x509 -req -in server.csr -text -days 365 \
  -CA root.crt -CAkey root.key -CAcreateserial \
  -out server.crt

echo "creating the container '$container_name'"
sudo docker build -t $container_name .
