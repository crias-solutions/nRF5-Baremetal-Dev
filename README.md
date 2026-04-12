# BLE Blinky

![nRF52840](https://img.shields.io/badge/nRF52840-DK-blue)
![SoftDevice](https://img.shields.io/badge/SoftDevice-S140%20v7.2-green)
![SDK](https://img.shields.io/badge/SDK-nRF5%20SDK%2017.1.0-orange)
![Toolchain](https://img.shields.io/badge/GCC-14.2-blue)
![License](https://img.shields.io/badge/License-Nordic%20BSD-yellow)

Bare-metal BLE development project for Nordic Semiconductor nRF52840 using the LED Button Service.

---

## WHY

This project provides a minimal, production-ready foundation for developing Bluetooth Low Energy applications on Nordic Semiconductor nRF52840 hardware without relying on Zephyr RTOS or nRF Connect SDK. It uses the standalone nRF5 SDK with pure GNU Make + GCC for full control over the build process and debugging experience.

The LED Button Service demonstrates core BLE peripheral patterns: advertising, connections, characteristic reads/writes, and notifications.

---

## HOW

### Architecture

```
ble_app_blinky/
├── main.c                          # Application entry point
├── pca10056/                       # Board-specific configuration
│   └── s140/
│       ├── armgcc/
│       │   └── Makefile            # Build with GNU Make
│       └── config/
│           └── sdk_config.h        # SDK module configuration
└── .vscode/                        # VS Code development environment
    ├── launch.json                  # J-Link debugging with RTT
    ├── tasks.json                   # Build tasks
    └── settings.json                # Toolchain paths
```

### Key Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Standalone nRF5 SDK | No Zephyr dependency, full bare-metal control |
| GNU Make + GCC | Open toolchain, portable, scriptable |
| J-Link + Cortex-Debug | Native debugging with RTT output |
| VS Code | Lightweight IDE, free, cross-platform |

### Development Flow

1. Edit `main.c` or `sdk_config.h`
2. Build with `Ctrl+Shift+B` or `make`
3. Flash with `make flash` or VS Code task
4. Debug with `F5` - RTT output in TERMINAL tab

---

## WHAT

### Core Features

- BLE peripheral advertising and connection handling
- LED Button Service (Nordic proprietary service)
- Button press triggers BLE notification to central device
- LED control via BLE write from central device
- SEGGER RTT logging for runtime diagnostics
- Full interrupt-driven architecture

### Three Key Components

1. **BLE Stack** - S140 SoftDevice handles BLE protocol
2. **Application** - LED Button Service implements peripheral logic
3. **Drivers** - nrfx drivers for GPIO, timers, peripherals

### Deliverables

- Compiled `.hex` and `.bin` firmware files
- Debug symbols for J-Link/GDB
- SVD file for peripheral register view

---

## Installation

### Prerequisites

| Tool | Version | Location |
|------|---------|----------|
| Arm GNU Toolchain | 14.2 | `C:\Program Files (x86)\Arm GNU Toolchain arm-none-eabi\14.2 rel1` |
| J-Link Software | V9+ | `C:\Program Files\SEGGER\JLink_V924a` |
| nrfjprog | Latest | Part of nRF Command Line Tools |
| Java | JDK 17+ | Required for CMSIS Configuration Wizard |
| VS Code | Latest | Recommended for development |

### Setup Steps

1. **Clone or copy this project**

2. **Install Arm GNU Toolchain**
   - Download from: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
   - Install to default location or note path for settings

3. **Install J-Link**
   - Download from: https://www.segger.com/downloads/jlink/
   - Install with default options

4. **Install nRF Command Line Tools**
   - Download from: https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools
   - Ensures `nrfjprog` is available in PATH

5. **Install Java** (for SDK Configuration Wizard)
   - Download Temurin JDK from: https://adoptium.net/
   - Add to PATH: `C:\Program Files\Eclipse Adoptium\jdk-*\bin`

6. **Install VS Code Extensions**
   - **Cortex-Debug** by marus25

7. **Flash SoftDevice** (one-time)
   ```bash
   make -C pca10056/s140/armgcc flash_softdevice
   ```

---

## Usage

### Build

```bash
# From project root
make -C pca10056/s140/armgcc

# Or in VS Code
Ctrl+Shift+B
```

### Flash

```bash
make -C pca10056/s140/armgcc flash
```

### Debug

1. Connect nRF52840 DK via USB
2. Press `F5` in VS Code
3. Debugger stops at `main()`
4. RTT output appears in TERMINAL tab

### SDK Configuration

Modify peripheral and module settings:

```bash
# F1 -> Tasks: Run Task -> SDK Config
```

Or edit `pca10056/s140/config/sdk_config.h` directly.

### Clean

```bash
make -C pca10056/s140/armgcc clean
```

---

## Configuration

### Toolchain Paths

Edit `.vscode/settings.json`:

```json
{
    "cortex-debug.armToolchainPath": "C:/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/14.2 rel1/bin",
    "cortex-debug.JLinkGDBServerPath": "C:/Program Files/SEGGER/JLink_V924a/JLinkGDBServer.exe"
}
```

### Device Target

Current target: **nRF52840_XXAA** on **PCA10056** (nRF52840 Development Kit)

To change targets, modify `pca10056/s140/armgcc/Makefile`:
- `TARGETS`: Change to desired build target
- `CFLAGS`: Update `-D` defines for device

### Build Output

| File | Location | Purpose |
|------|----------|---------|
| `.out` | `_build/nrf52840_xxaa.out` | ELF with debug symbols |
| `.hex` | `_build/nrf52840_xxaa.hex` | Flash programming |
| `.bin` | `_build/nrf52840_xxaa.bin` | Raw binary |
| `.map` | `_build/nrf52840_xxaa.map` | Linker map file |

---

## Testing

This is bare-metal firmware. Testing requires hardware:

1. **Functional Test**
   - Flash firmware to nRF52840 DK
   - Observe LED patterns
   - Connect from nRF Connect app or similar BLE central
   - Send LED on/off commands
   - Press button, verify notification received

2. **Debug Test**
   - Set breakpoint in `ble_evt_handler`
   - Trigger BLE connection
   - Inspect BLE event structure

3. **RTT Test**
   - Open TERMINAL tab in VS Code during debug
   - Verify log output appears

---

## License

This project uses Nordic Semiconductor's BSD 3-Clause License.

SPDX-License-Identifier: BSD-3-Clause

Redistribution and use in source and binary forms are permitted provided that the above copyright notice and this list of conditions are met. See LICENSE file for full text.

---

## References

- [nRF5 SDK Documentation](https://infocenter.nordicsemi.com/topic/sdk_nrf5_v17.1.0/home.html)
- [S140 SoftDevice Specification](https://infocenter.nordicsemi.com/topic/com.nordic.infocenter.softdevices52.s140/dita/softdevices/s140/intro.html)
- [nRF52840 Product Specification](https://infocenter.nordicsemi.com/topic/ps_nrf52840/modules.html)
- [Cortex-Debug Extension](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)
- [SEGGER J-Link](https://www.segger.com/downloads/jlink/)
