# Agent Guidelines for nRF5 Baremetal Project

## Quick Start (Docker)

```bash
# Build firmware
docker compose run build make -C pca10056/s140/armgcc

# Run OpenCode
docker compose run opencode
```

## Project Overview

- **SDK**: Nordic nRF5 SDK 17.1.0 (standalone, non-Zephyr)
- **Target**: nRF52840_XXAA (Cortex-M4 with FPU)
- **SoftDevice**: S140 BLE stack v7.2.0
- **Board**: PCA10056 (nRF52840 DK)
- **Build System**: GNU Make + GCC

## Build Commands (Host or Docker)

```bash
# Build (debug -O3 -g3)
make -C pca10056/s140/armgcc

# Clean artifacts
make -C pca10056/s140/armgcc clean

# Flash app (requires hardware + --privileged in Docker)
make -C pca10056/s140/armgcc flash

# Flash SoftDevice (one-time)
make -C pca10056/s140/armgcc flash_softdevice
```

## SDK Path

- **Default**: `/opt/nRF5_SDK_17.1.0_ddde560` (Docker) or set `SDK_ROOT` env var
- **Makefile**: Uses `SDK_ROOT ?=` so env override takes precedence

## Code Style

- **License Header**: Required (Nordic BSD)
- **Static functions**: `lower_snake_case` (e.g., `leds_init`)
- **Module instances**: `m_<module_name>` (e.g., `m_lbs`)
- **Constants**: `UPPER_SNAKE_CASE`
- **Structs**: Always zero-initialize with `{0}` or `memset()`

## BLE Event Handling

```c
static void ble_evt_handler(ble_evt_t const * p_ble_evt, void * p_context)
{
    switch (p_ble_evt->header.evt_id)
    {
        case BLE_GAP_EVT_CONNECTED: break;
        case BLE_GAP_EVT_DISCONNECTED: break;
        default: break;
    }
}
```

## Important Notes

1. **SoftDevice**: Must be flashed before app: `s140_nrf52_7.2.0_softdevice.hex`

2. **Interrupt Priorities**: Reserved (0,1,4,5). Use 2,3,6,7 for app code.

3. **Testing**: No unit tests. Test on hardware via J-Link debugger.

4. **VS Code**: Use Cortex-Debug extension with J-Link. RTT output in TERMINAL tab.