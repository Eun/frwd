FROM caddy:2.4.6-alpine


RUN apk add --no-cache openssh-server           && \
    adduser frwd -s /bin/ssh-entrypoint.sh -D   && \
    passwd -u frwd                              && \
    mkdir /etc/dropbear                         && \
    echo /bin/ssh-entrypoint.sh >> /etc/shells

COPY sshd_config /etc/ssh/sshd_config
COPY Caddyfile /etc/caddy/Caddyfile
COPY ssh-entrypoint.sh /bin/ssh-entrypoint.sh
COPY entrypoint.sh /bin/entrypoint.sh

EXPOSE 22/tcp
EXPOSE 80/tcp
EXPOSE 443/tcp

VOLUME ["/data"]

ENTRYPOINT "/bin/entrypoint.sh"
