FROM debian:buster

# Should we use NAT for our clients? - Yes, by default
ENV NAT=1

# Default port
ENV PORT=55555

# Server's public IP address
ENV PUBLIC_IP=1.2.3.4

# Custom DNS servers
ENV DNS="1.1.1.1, 1.0.0.1"

# Use unsafe (744) permissions in /etc/wireguard/clients
ARG CONFS_DIR_UNSAFE_PERMISSIONS=0
ENV WG_CLIENTS_UNSAFE_PERMISSIONS $WG_CLIENTS_UNSAFE_PERMISSIONS

# Turn off clientcontrol logs
ENV CLIENTCONTROL_NO_LOGS=0

# Copy tools
WORKDIR /srv
COPY start restart addclient clientcontrol /srv/
RUN chmod 755 /srv/*

ENV PATH="/srv:${PATH}"
VOLUME /etc/wireguard

# Set up WireGuard
RUN chmod 755 /srv/* \
    && echo "deb http://deb.debian.org/debian/ buster-backports main" > /etc/apt/sources.list.d/buster-backports.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends wireguard-tools iptables inotify-tools net-tools qrencode openresolv procps curl \
    && apt-get clean all

# Entrypoint
CMD [ "start" ]
