# How to create a new project from this template

This guide shows you how to adapt this bare-metal nRF5 template for your own project.

---

## Prerequisites

- Basic embedded C development knowledge
- nRF52840 DK (PCA10056) or compatible board
- For hardware flashing: J-Link debugger + nrfjprog
- For Docker development: Docker + Docker Compose

---

## Steps

### 1. Create project from template

```bash
# Clone this repository
git clone https://github.com/crias-solutions/nRF5-Baremetal-Dev.git your-project-name
cd your-project-name
```

### 2. Rename the project

Edit `pca10056/s140/armgcc/Makefile` and change `PROJECT_NAME`:

```makefile
PROJECT_NAME     := your_project_name
```

### 3. Configure SDK modules

Edit `pca10056/s140/config/sdk_config.h` to enable/disable modules:

- `NRF_LOG_ENABLED` - Enable/disable logging
- `BLE_ENABLED` - BLE stack
- `APP_TIMER_V2_ENABLED` - Timer module

Or run the SDK Config Wizard:

```bash
make -C pca10056/s140/armgcc sdk_config
```

### 4. Implement your application

Edit `main.c`:

- Keep the SoftDevice initialization if using BLE
- Modify or replace the LED Button Service
- Add your own peripherals, timers, callbacks

### 5. Build and verify

```bash
# Docker
docker compose run build make -C pca10056/s140/armgcc

# Or local (set SDK_ROOT first)
export SDK_ROOT=/path/to/nRF5_SDK_17.1.0_ddde560
make -C pca10056/s140/armgcc
```

Output: `pca10056/s140/armgcc/_build/nrf52840_xxaa.hex`

### 6. Flash to hardware

First flash the SoftDevice (one-time per board):

```bash
make -C pca10056/s140/armgcc flash_softdevice
```

Then flash your application:

```bash
make -C pca10056/s140/armgcc flash
```

---

## Variations

### Use a different board

To use a different board (e.g., nRF52832 DK):

1. Create a new board directory:

   ```bash
   mkdir -p pca10040/s132/armgcc
   mkdir -p pca10040/s132/config
   ```

2. Copy and adapt the Makefile from `pca10056/s140/armgcc/`

3. Copy and adapt sdk_config.h from `pca10056/s140/config/`

4. Update paths in the new `Makefile`:
   - `TARGETS` - e.g., `nrf52832_xxaa`
   - `LINKER_SCRIPT` - check SDK for correct linker file

### Use a different SoftDevice

To use S132 instead of S140:

1. Create a new SoftDevice directory (see above)

2. Update `Makefile` flags:

```makefile
CFLAGS += -DS132        # instead of S140
CFLAGS += -DNRF_SD_BLE_API_VERSION=6  # S132 uses API v6
```

3. Use the corresponding SoftDevice hex file for flashing

### Use Docker for development

```bash
# Build firmware
docker compose run build make -C pca10056/s140/armgcc

# Run OpenCode for AI assistance
docker compose run opencode
```

### Use local development (no Docker)

1. Install toolchain:
   - Arm GNU Toolchain (10.3+)
   - nrfjprog (nRF Command Line Tools)
   - Java 17+ (for SDK Config Wizard)

2. Download nRF5 SDK 17.1.0 from Nordic
3. Set environment variable:

   ```bash
   export SDK_ROOT=/path/to/nRF5_SDK_17.1.0_ddde560
   ```

4. Update toolchain path in `Makefile.posix` or pass via environment:

   ```bash
   make -C pca10056/s140/armgcc SDK_ROOT=$SDK_ROOT
   ```

---

## Next steps

- **Add a custom BLE service**: See `components/ble/ble_services/` in SDK for examples
- **Configure interrupts**: Priorities 0,1,4,5 are reserved for SoftDevice
- **Debug with RTT**: Use J-Link + Cortex-Debug in VS Code (see `.vscode/launch.json`)
- **Add more targets**: Edit `TARGETS` in Makefile to build for multiple devices

---

## Troubleshooting

**Build fails: Cannot find SDK**
```bash
# Verify SDK_ROOT is set correctly
echo $SDK_ROOT
ls -la $SDK_ROOT/components/toolchain/gcc/
```

**Flash fails: No J-Link device**
```bash
# Check device detection
nrfjprog --ids
```

**LED not blinking**
- Verify hardware connections
- Check pin mappings in `boards.h`
- Enable RTT logging to diagnose

---

## Reference

- SDK Documentation: https://infocenter.nordicsemi.com/topic/sdk_nrf5_v17.1.0/home.html
- SoftDevice S140: https://infocenter.nordicsemi.com/topic/com.nordic.infocenter.softdevices52.s140/dita/softdevices/s140/intro.html
- nRF52840 Product Spec: https://infocenter.nordicsemi.com/topic/ps_nrf52840/modules.html