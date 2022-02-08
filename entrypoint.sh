#!/bin/sh
set -euo pipefail

if [ -z "$DOMAIN" ]; then
  echo "\$DOMAIN is not defined"
  exit 1
fi

echo $DOMAIN > /etc/hostname

if [ -z "$AUTHORIZED_KEYS_BASE64" ]; then
  echo "\$AUTHORIZED_KEYS_BASE64 is not defined"
  exit 1
fi

echo "copying ssh keys"
echo $AUTHORIZED_KEYS_BASE64 | base64 -d > /etc/ssh/authorized_keys
if [ ! -s /etc/ssh/authorized_keys ]; then
  echo "\$AUTHORIZED_KEYS_BASE64 is empty"
  exit 1
fi

if [ ! -d /data/ ]; then
  mkdir "/data"
fi

if [ ! -d /data/sshd_keys ]; then
  mkdir "/data/sshd_keys"
fi

if [ ! -e /data/sshd_keys/ssh_host_ecdsa_key ]; then
  ssh-keygen -f /data/sshd_keys/ssh_host_ecdsa_key -N '' -t ecdsa -b 521
fi
if [ ! -e /data/sshd_keys/ssh_host_ed25519_key ]; then
  ssh-keygen -f /data/sshd_keys/ssh_host_ed25519_key -N '' -t ed25519
fi

echo "staring ssh"
/usr/sbin/sshd

echo "staring caddy"
caddy run -config /etc/caddy/Caddyfile -watch

