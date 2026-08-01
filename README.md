# Self-hosted media stack

This repo provides a small Docker Compose setup for serving media through a reverse proxy and Cloudflare Tunnel. It includes:

- [caddy/Caddyfile](caddy/Caddyfile) for reverse proxying to the local services
- [cloudflared/config.yml](cloudflared/config.yml) for the tunnel ingress rules
- [docker-compose.yml](docker-compose.yml) for the services themselves

The stack currently runs:

- Caddy
- Cloudflared
- Audiobookshelf
- Calibre Web
- Komga
- Navidrome

## Prerequisites

- Docker Desktop or OrbStack installed and running
- Docker Compose v2 (`docker compose`)
- [cloudflared](https://github.com/cloudflare/cloudflared) installed locally
- A local Jellyfin instance running on the host at `host.docker.internal:8096` (this repo does not start Jellyfin itself)
- The media folders you want to expose must exist at the paths you configure below

## Configuration

1. Copy [.env.example](.env.example) to [.env](.env) and update it for your environment.

  The env file controls:
  - the media library paths mounted into each service
  - the hostnames used by Caddy and the tunnel ingress rules
  - the Cloudflare tunnel ID and credentials filename

2. Make sure the Cloudflare Tunnel credentials JSON file exists in [cloudflared/](cloudflared). The filename should match the value in `CLOUDFLARED_CREDENTIALS_FILENAME`.

3. If needed, update [caddy/Caddyfile](caddy/Caddyfile) and [cloudflared/config.yml](cloudflared/config.yml) to match your hostnames and routing preferences.

## Cloudflare Tunnel setup

If you are configuring the tunnel for the first time:

```bash
cloudflared tunnel login
cloudflared tunnel create <tunnel-name>
```

Then create DNS records for the hostnames you want to expose:

```bash
cloudflared tunnel route dns <tunnel-name> jellyfin.mjjmedia.com
cloudflared tunnel route dns <tunnel-name> audiobooks.mjjmedia.com
cloudflared tunnel route dns <tunnel-name> music.mjjmedia.com
cloudflared tunnel route dns <tunnel-name> comics.mjjmedia.com
cloudflared tunnel route dns <tunnel-name> books.mjjmedia.com
```

Use the tunnel UUID from the `create` step for `CLOUDFLARED_TUNNEL_ID` in [.env](.env), and make sure the matching JSON credentials file is present in [cloudflared/](cloudflared).

## Docker volumes

Create the external Docker volumes used by the stack:

```bash
docker volume create abs-config
docker volume create abs-metadata
docker volume create caddy-config
docker volume create caddy-data
docker volume create calibre-web-config
docker volume create komga-config
docker volume create navidrome-data
```

## Start the services

Bring everything up:

```bash
docker compose up -d
```

Or start a single service first:

```bash
docker compose up -d <service-name>
```

## Service URLs

Once running, the services are expected to be reachable through the configured hostnames and the local exposed ports:

- Audiobookshelf: http://localhost:13378
- Calibre Web: http://localhost:8083
- Komga: http://localhost:25600
- Navidrome: http://localhost:4533

## Useful commands

```bash
# View logs
docker compose logs -f <service-name>

# Stop everything
docker compose down

# Rebuild/recreate a service after config changes
docker compose up -d --force-recreate <service-name>
```