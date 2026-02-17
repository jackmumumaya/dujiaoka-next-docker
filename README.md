# Dujiao-Next API

Dujiao-Next API is the backend service for the Dujiao-Next ecosystem. It provides public APIs, user/auth APIs, order and payment workflows, and admin APIs.

## Recent Updates & Features

### 1. Cryptocurrency Payment Integration (BEpusdt)

- Integrated **BEpusdt** as a payment gateway using the `epay` protocol.
- Added `usdt` as a selectable channel type in the Admin Panel.
- Updated database and configuration to support crypto payment flows.

### 2. Docker Deployment Enhancements

- **Port Reconfiguration**:
  - **Admin Panel**: Mapped to port `9091` (previously default).
  - **User Panel**: Mapped to port `9092`.
  - **API Service**: Port `9090` is now **internal only** within the Docker network, improving security.
- **Healthchecks**: Fixed Docker healthcheck configurations for the `dujiao-api` container to ensure stability during startup.

### 3. Bug Fixes

- **User Login**: Resolved 502 Bad Gateway errors affecting the user login functionality.
- **Theme Issues**: Fixed display consistency issues for the `riniba_04` theme.

## Tech Stack

- Go
- Gin
- GORM
- SQLite / PostgreSQL

## What This Service Does

- Serves REST APIs for user, order, and payment flows
- Handles payment callbacks/webhooks
- Supports product, fulfillment, and configuration management

## Quick Start (Local Dev)

```bash
go mod tidy
go run cmd/server/main.go
```

The default health check endpoint is:

- `GET /health`

## Deployment

For detailed deployment instructions, including the new Docker Compose setup, please refer to the [deploy/DEPLOY.md](deploy/DEPLOY.md) file.

## Online Documentation

- https://dujiaoka.com
