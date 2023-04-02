#!/bin/bash

set -e

cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ..

AWS_ACCESS_KEY_ID="XXXX"
AWS_SECRET_ACCESS_KEY="XXXX"
FQDN="openstack.alexisboissiere.fr"
EMAIL="alexisboissiere@epita.fr"

mkdir -p certbot

docker run -it --rm --name certbot \
    --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -v "$PWD/certbot:/etc/letsencrypt" \
    -v "$PWD/certbot:/var/lib/letsencrypt" \
    certbot/dns-route53 certonly \
    -d "${FQDN}" \
    -d int."${FQDN}" \
    -m "${EMAIL}" \
    --dns-route53 \
    --agree-tos  \
    --non-interactive

sudo chown -R "${USER}:${USER}" certbot

mkdir -p certificates
cat certbot/live/"${FQDN}"/fullchain.pem > ./certificates/haproxy.pem
cat certbot/live/"${FQDN}"/privkey.pem >> ./certificates/haproxy.pem
cp ./certificates/haproxy.pem ./certificates/haproxy-internal.pem
cat certbot/live/"${FQDN}"/fullchain.pem > ./certificates/backend-cert.pem
cat certbot/live/"${FQDN}"/privkey.pem > ./certificates/backend-key.pem