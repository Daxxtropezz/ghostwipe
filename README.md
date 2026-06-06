# ghostwipe

A lightweight Linux maintenance utility that automates system updates, package upgrades, cache cleanup, and routine housekeeping tasks to help keep your system secure, optimized, and running efficiently.

## Features

* Updates package repositories (`apt update`)
* Upgrades installed packages (`apt upgrade`)
* Removes unused dependencies (`apt autoremove`)
* Cleans APT package cache
* Clears user cache (`~/.cache`)
* Cleans temporary directories (`/tmp`, `/var/tmp`)
* Rotates and vacuums systemd journal logs
* Removes old log files
* Supports:

  * Full System Purge
  * Cache cleanup for files older than 7 days

## Supported Distributions

* Ubuntu
* Debian
* Linux Mint
* Pop!_OS
* Elementary OS

## Installation

### Ubuntu / Linux Mint / Pop!_OS

Add the Ghostwipe PPA:

```bash
sudo add-apt-repository ppa:daxxtropezz/ghostwipe
sudo apt update
sudo apt install ghostwipe
```

### Manual Installation

Clone the repository:

```bash
git clone https://github.com/daxxtropezz/ghostwipe.git
cd ghostwipe
```

Install dependencies:

```bash
sudo apt update
sudo apt install figlet lolcat fastfetch
```

Install Ghostwipe:

```bash
chmod +x ghostwipe
sudo install -m 755 ghostwipe /usr/local/bin/ghostwipe
```

## Usage

Run from any terminal:

```bash
ghostwipe
```

The utility can:

* Update system packages
* Clean APT caches
* Remove temporary files
* Clear user cache
* Rotate and vacuum journal logs
* Perform advanced cleanup operations

## Warning

The Full System Purge option permanently removes:

* Contents of `/tmp`
* Contents of `/var/tmp`
* User cache (`~/.cache`)
* Old journal logs
* Rotated log files

Review the script before using it on production or mission-critical systems.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
