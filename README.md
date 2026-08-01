# Self Hosting Media

## Initial Setup Guide
### Prerequisites
- Homebrew installed

### Installations
1. Install [Jellyfin](https://jellyfin.org):
    ```bash
    brew install jellyfin
    ```
2. Install [OrbStack](https://orbstack.dev):
    ```bash
    brew install orbstack
    ```
3. Install [cloudflared](https://github.com/cloudflare/cloudflared):
    ```bash
    brew install cloudflared
    ```

### Cloudflared Setup
1. Login:
```bash
cloudflared tunnel login
```
2. Create Tunnel:
```bash
cloudflared tunnel create neptune
```
3. Update (config.yml)[/cloudflared/config.yml] with the new UUID of the tunnel
4. Update (docker-compose.yml)[/docker-compose.yml] with the new UUID of the tunnel
4. Create DNS CNAME records for each subdomain
```bash
cloudflared tunnel route dns neptune jellyfin.mjjmedia.com
cloudflared tunnel route dns neptune audiobooks.mjjmedia.com
cloudflared tunnel route dns neptune music.mjjmedia.com
cloudflared tunnel route dns neptune comics.mjjmedia.com
cloudflared tunnel route dns neptune books.mjjmedia.com
```

### Docker Setup
Create volumes for the containers
```bash
docker volume create abs-config
docker volume create abs-metadata
docker volume create caddy-config
docker volume create caddy-data
docker volume create calibre-web-config
docker volume create komga-config
docker volume create navidrome-data
```

### Running Services
Bring up all docker services at once:
```bash
docker compose up -d
```

Or bring them up individually to perform initial setup/config on each service:
```bash
docker compose up -d <service name>
```