# home-hive

This repository contains NixOS configurations for a network of computers ("hive"). It uses Nix Flakes for reproducible builds and is managed with the help of the [nix_configs](https://github.com/coreyoconnor/nix_configs) flake.

## Development

To enter a development shell with necessary tools, run:
```bash
nix develop
```

## PostPi (Raspberry Pi) Setup

### Build Images

To build the Raspberry Pi images:
```bash
./bin/build-postpi-images.sh
```

### Flash Images

1. Decompress the generated image: `unzstd <image-file.zst>`
2. Put the Raspberry Pi into flashing mode: `sudo rpiboot`
3. Write the image to the device: `dd if=<decompressed image> of=/dev/sdX` (replace `sdX` with the correct device)

### Serial Console

Connect to the serial console using `minicom`:
```bash
minicom --color on --baudrate 115200 --device /dev/ttyUSB0
```

#### USB to Serial Adapter Wiring

- **Red:** Leave disconnected
- **GND (Black):** Pin 6
- **TXD (White):** GPIO 14 (Pin 8)
- **RXD (Green):** GPIO 15 (Pin 10)

Alternatively, you can connect with `screen`:
```bash
screen /dev/tty.??? 115200
```
