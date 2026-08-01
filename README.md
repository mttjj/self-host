# Self-hosted media stack

This repo provides a small Docker Compose setup for serving media through a reverse proxy and Cloudflare Tunnel. It includes:

- [caddy/Caddyfile](caddy/Caddyfile) for reverse proxying to the local services
- [cloudflared/config.yml](cloudflared/config.yml) for the tunnel ingress rules
- [docker-compose.yml](docker-compose.yml) for the services themselves

## Prerequisites

- [OrbStack](https://orbstack.dev) installed and running
- [cloudflared](https://github.com/cloudflare/cloudflared) installed locally
- A local [Jellyfin](https://jellyfin.org) instance running on the host

## Cloudflare Tunnel Setup
Configure the tunnel for the first time:

```bash
cloudflared tunnel login
```

Create the tunnel:
```bash
cloudflared tunnel create neptune
```
Cloudflared will create and place some files in a `~/.cloudflared` directory. Make note of the tunnel UUID as it will be needed later.

Then create DNS records to expose the hostnames:

```bash
cloudflared tunnel route dns neptune jellyfin.mjjmedia.com && \
cloudflared tunnel route dns neptune audiobooks.mjjmedia.com && \
cloudflared tunnel route dns neptune music.mjjmedia.com && \
cloudflared tunnel route dns neptune comics.mjjmedia.com && \
cloudflared tunnel route dns neptune books.mjjmedia.com
```

## Docker volumes

Create the external Docker volumes used by the stack:

```bash
docker volume create abs-config && \
docker volume create abs-metadata && \
docker volume create caddy-config && \
docker volume create caddy-data && \
docker volume create calibre-web-config && \
docker volume create komga-config && \
docker volume create navidrome-data
```

## Configuration

1. Copy [.env.example](.env.example) to `.env` and update the Cloudflare details with the UUID copied from the cloudflared steps above


## Start the services

Bring everything up:

```bash
docker compose up -d
```

Or start a single service first:

```bash
docker compose up -d <service-name>
```