FROM caddy:2.4.6-alpine


RUN apk add --no-cache dropbear haproxy &&         \
    adduser frwd -s /bin/http-entrypoint.sh -D &&  \
    mkdir /home/frwd/.ssh &&                       \
    mkdir /etc/dropbear && \
    echo /bin/http-entrypoint.sh >> /etc/shells

COPY Caddyfile /etc/caddy/Caddyfile
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY http-entrypoint.sh /bin/http-entrypoint.sh
COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT "/bin/entrypoint.sh"
