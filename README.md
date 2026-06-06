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

## Prerequisites

Ghostwipe is designed for Debian-based Linux distributions that use APT, including:

* Ubuntu
* Debian
* Linux Mint
* Pop!_OS
* Elementary OS

Install the required dependencies:

```bash
sudo apt update
sudo apt install figlet lolcat fastfetch
```

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/ghostwipe.git
cd ghostwipe
```

Make sure the script is executable:

```bash
chmod +x ghostwipe
```

Install Ghostwipe system-wide:

```bash
sudo install -m 755 ghostwipe /usr/local/bin/ghostwipe
```

Verify the installation:

```bash
which ghostwipe
```

Expected output:

```text
/usr/local/bin/ghostwipe
```

## Usage

Run Ghostwipe from anywhere in your terminal:

```bash
ghostwipe
```

The utility will:

1. Display system information and status.
2. Ask whether to run package updates and cleanup.
3. Optionally perform advanced cache cleanup.
4. Allow choosing between:

   * Full System Purge
   * Remove Cache Older Than 7 Days

## Warning

The **Full System Purge** option permanently removes:

* Contents of `/tmp`
* Contents of `/var/tmp`
* User cache (`~/.cache`)
* Old journal logs
* Rotated log files

Review the script before running it on production or critical systems.

## License

[LICENSE](MIT LICENSE)
