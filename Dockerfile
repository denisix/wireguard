FROM alpine:3.23
LABEL description="Wireguard VPN" org.opencontainers.image.authors="github.com/denisix" maintainer="denisix <denisix@gmail.com>"

# ENVIRONMENT VARIABLES:
#
# NAT=1                  - Should we use NAT for our clients? - Yes, by default
# INTERFACE=eth0         - Which interface to use?
# PORT=55555             - Port to use for WireGuard
# PUBLIC_IP=1.2.3.4      - Server's public IP address
# DNS=1.1.1.1            - Custom DNS servers
# SUBNET_IP=10.88.0.1/16 - first IP in private subnet (with subnet declaration), client IPs will follow like 10.88.0.2, 10.88.0.3, ..
# CLIENTCONTROL_NO_LOGS=0 - Turn off clientcontrol logs
# WG_CLIENTS_UNSAFE_PERMISSIONS=0 - Use unsafe (744) permissions in /etc/wireguard/clients
# TCPMSS=1400

ENV \
  NAT=1 \
  INTERFACE=eth0 \
  PORT=55555 \
  PUBLIC_IP=1.2.3.4 \
  DNS=8.8.8.8,8.8.4.4 \
  SUBNET_IP=10.88.0.1/16 \
  CLIENTCONTROL_NO_LOGS=0 \
  WG_CLIENTS_UNSAFE_PERMISSIONS=0 \
  TCPMSS=1400 \
  MTU=1384 \
  PATH="/srv:$PATH"

VOLUME /etc/wireguard

# Copy tools
WORKDIR /srv
COPY start restart addclient clientcontrol /srv/

# Install WireGuard and dependencies
# hadolint ignore=DL3008
RUN chmod 755 /srv/* \
    && apk add --no-cache wireguard-tools iptables inotify-tools libqrencode-tools openresolv procps wget iproute2

HEALTHCHECK --interval=5s --timeout=5s CMD /sbin/ip -o li sh wg0 || exit 1

# Entrypoint
CMD [ "start" ]
