#!/bin/bash

port=443
domain=www.example.com
user=xxxxx
password=yyyyy

sudo docker run -d --name gost \
    -v ${CERT_DIR}:${CERT_DIR}:ro \
    --net=host ginuerzh/gost \
    -L "http2://${user}:${password}@0.0.0.0:${port}?cert=/etc/letsencrypt/live/${domain}/fullchain.pem&key=/etc/letsencrypt/live/${domain}/privkey.pem&probe_resist=file:/var/www/html/index.html&knock=www.google.com"