#!/usr/bin/env bash

UUID=${UUID:-'b15a6e60-7d02-499a-a3a7-82d5381f9b6c'}
VM_WS=${VM_WS:-'/vm'}
VL_WS=${VL_WS:-'/vl'}
TR_WS=${TR_WS:-'/tr'}
WG_PRIV=${WG_PRIV:-'GAl2z55U2UzNU5FG+LW3kowK+BA/WGMi1dWYwx20pWk='}
sed -i "s#UUID#$UUID#g;s#VM_WS#${VM_WS}#g;s#VL_WS#${VL_WS}#g;s#TR_WS#${TR_WS}#g;s#WG_PRIV#${WG_PRIV}#g" config.json
sed -i "s#VM_WS#${VM_WS}#g;s#VL_WS#${VL_WS}#g;s#TR_WS#${TR_WS}#g" /etc/nginx/nginx.conf

rm -rf /usr/share/nginx/*
wget https://github.com/r3d5ky/sb-paas-dev/raw/main/game.zip -O /usr/share/nginx/game.zip
unzip -o "/usr/share/nginx/game.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/game.zip

RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv sing-box ${RELEASE_RANDOMNESS}
cat config.json | base64 > config
rm -f config.json

nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} run -c config.json
