# Project Overview

This repository, "home-hive," is a comprehensive NixOS configuration for managing a network of computers (a "hive"). It utilizes Nix Flakes to ensure reproducible builds and deployments. The configurations are highly modular, with clear separation for different machines, hardware, services, and network settings.

A key component of this setup is the use of the [nix_configs](https://github.com/coreyoconnor/nix_configs) flake, which acts as a library to provide abstractions that simplify the creation of each computer's configuration.

The project is structured to manage several distinct machines, including servers, desktops, and Raspberry Pi devices. It leverages NixOS modules to create reusable and composable configurations, making it easy to maintain and extend the system.

## Building and Running

The primary tool for building and deploying configurations is `colmena`, as indicated by the `bin/build-postpi-images.sh` script.

### Building Raspberry Pi Images

To build the Raspberry Pi images, run the following script:

```bash
./bin/build-postpi-images.sh
```

This will create `sd-image` builds for the `postpi` machines.

### Flashing Raspberry Pi Images

After building, the images can be flashed to an SD card.

1.  Decompress the image: `unzstd <image-file>`
2.  Use `rpiboot` to prepare the Raspberry Pi.
3.  Flash the image using `dd`: `sudo dd if=<decompressed-image> of=/dev/sdX bs=4M conv=fsync`

### Development Environment

The development environment is managed by Nix. You can enter a development shell by running:

```bash
nix develop
```

This will provide a shell with the tools specified in `devshell.toml`, such as `minicom` and `rpiboot`.

## Development Conventions

### Directory Structure

The repository is organized into the following key directories:

*   `computers/`: Contains the main configuration for each individual machine in the hive.
*   `modules/`: Provides reusable NixOS modules for configuring various aspects of the system, such as desktop environments, services, and hardware.
*   `hardware/`: Defines hardware-specific configurations for different CPU architectures and devices.
*   `defaults/`: Contains the base NixOS configuration that is shared across all machines.
*   `network/`: Manages the network configuration for the hive.
*   `installer/`: Defines the configuration for a custom NixOS installer.
*   `bin/`: Contains helper scripts for building and managing the system.

### Adding a New Machine

To add a new machine to the hive:

1.  Create a new directory in `computers/` for the machine.
2.  Create a `default.nix` file in the new directory, importing the necessary modules and defining the machine-specific configuration.
3.  Add the new machine to the `outputs.systems` map in `flake.nix`.

### Custom Modules

Custom NixOS modules are located in the `modules/` directory. These modules can be imported into machine configurations to provide specific functionality. When creating a new module, follow the standard NixOS module conventions, defining options and configuration settings.
