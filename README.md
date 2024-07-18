![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/denisix/wireguard?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/denisix/wireguard?style=flat-square)

# Wireguard VPN

Easy Wireguard server setup using Docker Engine

Information related to Wireguard VPN you can find at official website - [https://www.wireguard.com/](https://www.wireguard.com/)

## Requirements

- GNU/Linux host with a recent kernel (5.x)
- Wireguard module: in modern linux it's already exists, so verify by `modprobe wireguard`, if no module install using:

```sh
sudo apt install wireguard-tools
```

- installed [Docker](https://docs.docker.com/engine/install/) Engine

## Setup

- manual run

```sh
docker run --rm \
  --cap-add sys_module \
  --cap-add net_admin \
  -e PUBLIC_IP=1.2.3.4 \
  -e PORT=55555 \
  -e DNS=8.8.8.8,8.8.4.4 \
  -e SUBNET_IP=10.88.0.1/16 \
  -v ./wireguard:/etc/wireguard \
  -p 55555:55555/udp denisix/wireguard
```

- Sample **[docker-compose.yml](https://raw.githubusercontent.com/denisix/wireguard/main/docker-compose.yml)** file:

```docker-compose.yml
version: "3"
services:

  wireguard:
    image: denisix/wireguard
    environment:
      - PUBLIC_IP=1.2.3.4
      - PORT=55555
      - DNS=8.8.8.8,8.8.4.4
      - SUBNET_IP=10.88.0.1/16
    volumes:
      - ./wireguard/:/etc/wireguard/
    ports:
      - 55555:55555/udp
    cap_add:
      - SYS_MODULE
      - NET_ADMIN
    restart: unless-stopped
```

To start your instance:

```sh
docker-compose up -d wireguard
```

There will be a **QR code** within the container's logs for the test user:

```sh
docker-compose logs wireguard
```

...as well as simple copy-paste instructions for your desktop clients :)

Adding a **new client** peer is easy:

```sh
docker-compose exec wireguard addclient client1
```

Available environment variables:

| VARIABLE                    | DESCRIPTION                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| NAT=1                       | Should we use NAT for our clients? - Yes, by default                        |
| INTERFACE=eth0              | Which interface to use?                                                     |
| PORT=55555                  | Port to use for WireGuard                                                   |
| PUBLIC_IP=1.2.3.4           | Server's public IP address                                                  |
| DNS=1.1.1.1                 | Custom DNS servers                                                          |
| SUBNET_IP=10.88.0.1/16      | First IP in private subnet (with subnet declaration), client IPs will follow like 10.88.0.2, 10.88.0.3, .. |
| CLIENTCONTROL_NO_LOGS=0     | Turn off clientcontrol logs                                                 |
| WG_CLIENTS_UNSAFE_PERMISSIONS=0 | Use unsafe (744) permissions in /etc/wireguard/clients                  |
| TCPMSS=1400                 | Provide TCPMSS value so the connected clients can adjust their MTU          |

Additionaly you can set custom post up / post down scripts to execute by overriding the following scripts in your docker-compose configuration:
- /etc/wireguard/postup
- /etc/wireguard/postdown

> P.S.: Please give [this repo](https://github.com/denisix/wireguard) a star if you like it :wink:
