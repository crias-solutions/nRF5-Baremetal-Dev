# nRF5 Bare-metal Template

![nRF52840](https://img.shields.io/badge/nRF52840-DK-blue)
![SoftDevice](https://img.shields.io/badge/SoftDevice-S140%20v7.2-green)
![SDK](https://img.shields.io/badge/SDK-nRF5%20SDK%2017.1.0-orange)
![License](https://img.shields.io/badge/License-Nordic%20BSD-yellow)

Bare-metal Nordic nRF5 SDK project template with working LED Button Service example.

---

## WHY

This template provides a production-ready foundation for bare-metal development on Nordic Semiconductor nRF5 devices. It uses the standalone nRF5 SDK with pure GNU Make + GCC, giving full control over the build process without Zephyr RTOS dependencies.

The LED Button Service demonstrates core BLE peripheral patterns: advertising, connections, characteristic reads/writes, and notifications.

---

## HOW

### Quick Start (Docker)

```bash
# Build firmware
docker compose run build make -C pca10056/s140/armgcc

# Run OpenCode
docker compose run opencode
```

### Architecture

```
nrf5-baremetal-template/
├── main.c                              # Application entry (LED Button Service)
├── pca10056/s140/armgcc/               # Board/SoftDevice config
│   ├── Makefile                        # Build with GNU Make
│   └── config/sdk_config.h             # SDK configuration
├── Dockerfile                          # Docker build environment
├── docker-compose.yml                  # Docker services
├── DOCKER.md                           # Docker documentation
├── AGENTS.md                           # Agent guidelines
└── .vscode/                            # VS Code config (host development)
```

### Key Decisions

| Decision | Rationale |
|----------|-----------|
| Standalone nRF5 SDK | No Zephyr, full bare-metal control |
| GNU Make + GCC | Open toolchain, portable |
| Docker | Self-contained build environment |
| J-Link + Cortex-Debug | Debugging with RTT output |

---

## WHAT

### Core Features

- BLE peripheral advertising (device: "Nordic_Blinky")
- LED1 fast blink (250ms) during advertising
- LED2 ON when connected
- LED3 toggles via button or BLE write
- SEGGER RTT logging for diagnostics

### Three Key Components

1. **BLE Stack** - S140 SoftDevice handles BLE protocol
2. **Application** - LED Button Service implements peripheral logic
3. **Drivers** - nrfx drivers for GPIO, timers, peripherals

### LED Behavior

| State | LED1 (Advertising) | LED2 (Connected) | LED3 (LEDBUTTON) |
|-------|-------------------|------------------|------------------|
| Advertising | **Fast blink (250ms)** | OFF | Last state |
| Connected | OFF | **ON** | Button toggles |
| Disconnected | **Fast blink** | OFF | Last state |

### Deliverables

- `.hex` - Flash programming
- `.bin` - Raw binary
- `.out` - ELF with debug symbols

---

## Installation

### Option 1: Docker (Recommended)

```bash
# Build the container
docker compose build

# Build firmware
docker compose run build make -C pca10056/s140/armgcc
```

Output: `pca10056/s140/armgcc/_build/nrf52840_xxaa.hex`

### Option 2: Local Development

| Tool | Version |
|------|---------|
| Arm GNU Toolchain | 10.3+ |
| nrfjprog | 10.15+ |
| Java | JDK 17+ |

Set `SDK_ROOT` to your nRF5 SDK path:

```bash
export SDK_ROOT=/path/to/nRF5_SDK_17.1.0_ddde560
make -C pca10056/s140/armgcc
```

---

## Usage

### Flash Firmware

```bash
# Docker (requires --privileged + USB)
docker compose run --privileged build make -C pca10056/s140/armgcc flash

# Host
make -C pca10056/s140/armgcc flash
```

### Flash SoftDevice (one-time)

```bash
make -C pca10056/s140/armgcc flash_softdevice
```

### First Boot

1. Connect nRF52840 DK via USB
2. Flash firmware
3. LED1 blinks fast (250ms) - device advertising
4. Connect from nRF Connect app ("Nordic_Blinky")
5. LED1 stops, LED2 turns ON
6. Press Button 1 - LED3 toggles

---

## License

This project uses Nordic Semiconductor's BSD 3-Clause License.

SPDX-License-Identifier: BSD-3-Clause

See LICENSE file for full text.

---

## References

- [nRF5 SDK Documentation](https://infocenter.nordicsemi.com/topic/sdk_nrf5_v17.1.0/home.html)
- [S140 SoftDevice Specification](https://infocenter.nordicsemi.com/topic/com.nordic.infocenter.softdevices52.s140/dita/softdevices/s140/intro.html)
- [nRF52840 Product Specification](https://infocenter.nordicsemi.com/topic/ps_nrf52840/modules.html)