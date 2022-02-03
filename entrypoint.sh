#!/bin/sh

if [ -z "$DOMAIN" ]; then
  echo "\$DOMAIN is not defined"
  exit 1
fi

if [ -z "$AUHORIZED_KEYS_BASE64" ]; then
  echo "\$AUHORIZED_KEYS_BASE64 is not defined"
  exit 1
fi

echo "copying ssh keys"
echo $AUHORIZED_KEYS_BASE64 | base64 --decode > /home/http/.ssh/authorized_keys
chmod -R 0600 /home/http/.ssh
chown -hR http:http /home/http


echo "staring dropbear"
dropbear -R                        `# Create hostkeys as required` \
         -m                        `# Don't display the motd on login` \
         -w                        `# Disallow root logins` \
         -s                        `# Disable password logins` \
         -T 3                      `# Maximum authentication tries` \
         -k                        `# Disable remote port forwarding` \
         -c /bin/ssh-entrypoint.sh `# Force executed command` \
         -p 22                     `# Listen on port`

echo "staring haproxy"
haproxy -f /etc/haproxy/haproxy.cfg -D

echo "staring caddy"
caddy run -config /etc/caddy/Caddyfile -watch

