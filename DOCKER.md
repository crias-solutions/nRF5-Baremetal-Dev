# Docker Build Environment

This project includes a Docker container for building nRF5 firmware without needing to install the toolchain locally.

## What's Included

- **Ubuntu 22.04** base
- **Arm GNU Toolchain** (gcc-arm-none-eabi 10.3)
- **nRF5 SDK 17.1.0** (downloaded during build)
- **nRF Command Line Tools** (nrfjprog)
- **OpenCode** pre-installed
- **Java 17** (for SDK Config Wizard)

## Quick Start

```bash
# Build the Docker image
docker compose build

# Build firmware
docker compose run build make -C pca10056/s140/armgcc

# Run OpenCode
docker compose run opencode
```

## Build Output

After building, firmware files are in `pca10056/s140/armgcc/_build/`:

| File | Purpose |
|------|---------|
| `.out` | ELF with debug symbols |
| `.hex` | Flash programming |
| `.bin` | Raw binary |
| `.map` | Linker map |

## Flashing to Hardware

The container includes `nrfjprog` for flashing. Requires USB device pass-through:

```bash
# Flash app (requires --privileged + USB access)
docker compose run --privileged build make -C pca10056/s140/armgcc flash

# Flash SoftDevice
docker compose run --privileged build make -C pca10056/s140/armgcc flash_softdevice
```

## Customization

- **SDK_ROOT**: Defaults to `/opt/nRF5_SDK_17.1.0_ddde560`. Override in docker-compose.yml if needed.
- **Toolchain**: The Makefile uses system gcc-arm-none-eabi (v10.3). SDK config auto-detected.