# NeoFeeder Swarm Mode

Run multiple NeoFeeder instances on a single Docker host using Docker Swarm.

## Why Swarm?

The original docker-compose uses a hardcoded network subnet (`192.167.150.0/24`) that the encrypted app binary requires. Docker Swarm's overlay networking provides isolated network namespaces, allowing multiple instances to use the same internal subnet without conflict.

## Directory Structure

```
neofeeder/
├── .swarm/               # Swarm configuration & scripts
│   ├── DockerfileSwarm
│   ├── swarm.yml
│   ├── pg_hba.conf
│   ├── setup-swarm.sh
│   ├── build-image.sh
│   └── deploy.sh
├── stiembo/              # Instance 1
│   ├── app/
│   ├── etc/supervisor/
│   ├── nginx/
│   ├── pgsql/data/
│   └── prefill_pddikti/
└── iikplmn/              # Instance 2
    ├── app/
    ├── etc/supervisor/
    ├── nginx/
    ├── pgsql/data/
    └── prefill_pddikti/
```

## Quick Start

### 1. Initialize Docker Swarm (one-time setup)
```bash
.swarm/setup-swarm.sh
```

### 2. Build images for each instance
```bash
.swarm/build-image.sh stiembo
.swarm/build-image.sh iikplmn
```

### 3. Deploy with unique ports
```bash
.swarm/deploy.sh stiembo 8100 3003
.swarm/deploy.sh iikplmn 8200 3103
```

## Managing Stacks

```bash
# List all stacks
docker stack ls

# List services in a stack
docker stack services neofeeder-stiembo

# View logs
docker service logs neofeeder-stiembo_app-pddikti

# Remove a stack
docker stack rm neofeeder-stiembo
```

## Port Allocation

| Instance | Web Port | Webservice Port |
|----------|----------|----------------|
| stiembo  | 8100     | 3003           |
| iikplmn  | 8200     | 3103           |
| (next)   | 8300     | 3203           |

## Files in .swarm/

| File | Description |
|------|-------------|
| `DockerfileSwarm` | Builds app into image for Swarm deployment |
| `swarm.yml` | Stack deployment template |
| `pg_hba.conf` | PostgreSQL authentication config |
| `setup-swarm.sh` | Initialize Docker Swarm |
| `build-image.sh` | Build image for an instance |
| `deploy.sh` | Deploy a stack with custom ports |
