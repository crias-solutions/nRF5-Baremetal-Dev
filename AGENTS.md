# Agent Guidelines for nrf5-baremetal-template

## Project Overview

Nordic Semiconductor nRF5 SDK bare-metal project template with LED Button Service example on nRF52840.

- **SDK**: Nordic nRF5 SDK 17.1.0 (standalone, non-Zephyr)
- **Target**: nRF52840_XXAA (Cortex-M4 with FPU)
- **SoftDevice**: S140 BLE stack v7.2.0
- **Board**: PCA10056 (nRF52840 DK)
- **Toolchain**: Arm GNU Toolchain arm-none-eabi 14.2
- **Build System**: GNU Make + GCC

---

## Build Commands

### Build
```bash
make -C pca10056/s140/armgcc              # Build (debug -O3 -g3)
make -C pca10056/s140/armgcc clean        # Clean artifacts
```

### Other Targets
```bash
make -C pca10040/s132/armgcc              # nRF52832
make -C pca10059/s140/armgcc              # nRF52840
```

### Flash
```bash
make -C pca10056/s140/armgcc flash                    # Flash app
make -C pca10056/s140/armgcc flash_softdevice         # Flash S140
make -C pca10056/s140/armgcc erase                    # Erase all
```

### VS Code
- **Build**: `Ctrl+Shift+B`
- **Debug**: `F5` (with RTT in TERMINAL tab)
- **SDK Config**: `F1` → Tasks → SDK Config

---

## Code Style Guidelines

### License Header (Required)
Every source file must include the Nordic Semiconductor BSD license header.

### Doxygen Documentation
```c
/**@brief Function for the LEDs initialization.
 *
 * @details Initializes all LEDs used by the application.
 */
static void leds_init(void)
```

### Naming Conventions
- **Static functions**: `lower_snake_case` (e.g., `leds_init`, `ble_evt_handler`)
- **Module instances**: `m_<module_name>` (e.g., `m_lbs`, `m_gatt`)
- **Module definitions**: `<MODULE>_DEF(<name>)` (e.g., `BLE_LBS_DEF(m_lbs)`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `ADVERTISING_LED`, `DEVICE_NAME`)

### Error Handling
```c
ret_code_t err_code;
err_code = some_function();
APP_ERROR_CHECK(err_code);

// For expected errors:
if (err_code != NRF_SUCCESS &&
    err_code != BLE_ERROR_INVALID_CONN_HANDLE &&
    err_code != NRF_ERROR_INVALID_STATE)
{
    APP_ERROR_CHECK(err_code);
}
```

### Module Instance Pattern
```c
BLE_LBS_DEF(m_lbs);
NRF_BLE_GATT_DEF(m_gatt);
NRF_BLE_QWR_DEF(m_qwr);

static uint16_t m_conn_handle = BLE_CONN_HANDLE_INVALID;
```

### Memory Initialization
Always zero-initialize structs:
```c
ble_lbs_init_t init = {0};
memset(&gap_conn_params, 0, sizeof(gap_conn_params));
```

### BLE Event Handling
```c
static void ble_evt_handler(ble_evt_t const * p_ble_evt, void * p_context)
{
    switch (p_ble_evt->header.evt_id)
    {
        case BLE_GAP_EVT_CONNECTED:
            break;
        case BLE_GAP_EVT_DISCONNECTED:
            break;
        default:
            break;
    }
}
```

### Include Order
1. Standard headers (`<stdint.h>`, `<string.h>`)
2. Nordic headers (`nordic_common.h`, `nrf.h`)
3. nrfx/nRF drivers (`nrfx_*.h`, `app_*.h`)
4. BLE stack (`ble.h`, `ble_srv_common.h`)
5. Board/utility (`boards.h`, `app_error.h`)
6. Application-specific headers
7. NRF_LOG headers

---

## SDK Paths

- **SDK Root**: `C:/nordic/Donwloads/nRF5_SDK_17.1.0_ddde560`
- **Toolchain**: `C:/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/14.2 rel1/bin/`
- **J-Link**: `C:/Program Files/SEGGER/JLink_V924a/`
- **SVD**: `$(SDK_ROOT)/modules/nrfx/mdk/nrf52840.svd`

---

## Project Structure

```
nrf5-baremetal-template/
├── main.c                          # Application entry point (LED Button Service example)
├── pca10056/s140/armgcc/Makefile   # Build config
├── pca10056/s140/config/sdk_config.h  # SDK configuration
└── .vscode/                        # VS Code config
    ├── launch.json                  # Debug with RTT
    ├── tasks.json                   # Build tasks
    └── settings.json                # Toolchain paths
```

---

## Important Notes

1. **SDK Modification**: Configure via `sdk_config.h` or Makefile defines. Don't modify SDK source.

2. **SoftDevice**: S140 must be flashed first:
   `$(SDK_ROOT)/components/softdevice/s140/hex/s140_nrf52_7.2.0_softdevice.hex`

3. **GCC 14 Compatibility**: `-Wno-error` is used to suppress false positives.

4. **Interrupt Priorities**: On nRF52, priorities 0,1,4,5 are reserved for SoftDevice. Use 2,3,6,7.

5. **Testing**: Bare-metal embedded project with **no unit tests**. Test on hardware via debug sessions.
