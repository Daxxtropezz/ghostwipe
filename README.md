# Ghostwipe

<div align="center">

**Linux Maintenance & Cleanup Utility**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-Jammy%20%7C%20Resolute-orange.svg)](https://ubuntu.com/)
[![PPA](https://img.shields.io/badge/PPA-Available-brightgreen.svg)](https://launchpad.net/~daxxtropezz/+archive/ubuntu/ghostwipe)
[![Bash](https://img.shields.io/badge/Bash-Script-blue.svg)](https://www.gnu.org/software/bash/)

*A lightweight and professional Linux maintenance utility for Debian-based distributions.*

</div>

---

## Overview

Ghostwipe is an open-source system maintenance utility designed to simplify routine Linux administration tasks. It automates package updates, cache cleanup, temporary file management, journal maintenance, and general system housekeeping through both an interactive menu and command-line subcommands.

Whether you're a Linux enthusiast, system administrator, or power user, Ghostwipe helps keep your system secure, organized, and running efficiently.

---

## Features

### System Maintenance

* Update package repositories (`apt update`)
* Upgrade installed packages (`apt upgrade`)
* Remove unused dependencies (`apt autoremove`)
* Clean APT package cache
* Clean temporary files and directories
* Rotate and vacuum systemd journal logs
* Remove outdated log files

### Cleanup Modes

| Mode             | Description                                          |
| ---------------- | ---------------------------------------------------- |
| Safe Cleanup     | Removes temporary files and cache older than 7 days  |
| Deep Cleanup     | Performs a complete cache and temporary file cleanup |
| Full Maintenance | Runs system updates and safe cleanup together        |

### Professional Interface

* Interactive menu system
* Command-line subcommands
* Colorized output using `lolcat`
* ASCII banner powered by `figlet`
* Optional system information display using `fastfetch`
* Structured logging and status messages
* Safety confirmations for destructive operations

---

## Supported Distributions

Ghostwipe is designed for Debian-based Linux distributions:

| Distribution                | Supported |
| --------------------------- | --------- |
| Ubuntu Jammy (22.04 LTS)    | ✅         |
| Ubuntu Resolute (26.04 LTS) | ✅         |
| Ubuntu Noble (24.04 LTS)    | ✅         |

---

## Installation

### Method 1: Launchpad PPA (Recommended)

Install Ghostwipe directly from the official Launchpad PPA:

```bash
sudo add-apt-repository ppa:daxxtropezz/ghostwipe
sudo apt update
sudo apt install ghostwipe
```

---

### Method 2: Manual Installation

Clone the repository:

```bash
git clone https://github.com/Daxxtropezz/ghostwipe.git
cd ghostwipe
```

Install optional dependencies:

```bash
sudo apt update
sudo apt install figlet lolcat fastfetch
```

Install Ghostwipe system-wide:

```bash
chmod +x ghostwipe
sudo install -m 755 ghostwipe /usr/local/bin/ghostwipe
```

Verify installation:

```bash
ghostwipe version
```

---

## Usage

### Interactive Mode

Launch the interactive menu:

```bash
ghostwipe
```

---

### Command Line Mode

Update and upgrade the system:

```bash
ghostwipe update
```

Perform safe cleanup:

```bash
ghostwipe clean
```

Perform deep cleanup:

```bash
ghostwipe deep-clean
```

Display system information:

```bash
ghostwipe info
```

Show version:

```bash
ghostwipe version
```

Show help:

```bash
ghostwipe --help
```

or

```bash
ghostwipe -h
```

---

## Command Reference

| Command                | Description                        |
| ---------------------- | ---------------------------------- |
| `ghostwipe`            | Launch interactive menu            |
| `ghostwipe update`     | Update and upgrade system packages |
| `ghostwipe clean`      | Perform safe cleanup               |
| `ghostwipe deep-clean` | Perform deep cleanup               |
| `ghostwipe info`       | Display system information         |
| `ghostwipe version`    | Show installed version             |
| `ghostwipe help`       | Show help information              |
| `ghostwipe -h`         | Show help information              |
| `ghostwipe --help`     | Show help information              |
| `ghostwipe -v`         | Show version                       |
| `ghostwipe --version`  | Show version                       |

---

## Safety Notice

The **Deep Cleanup** option may remove:

* Temporary files from `/tmp`
* Temporary files from `/var/tmp`
* User cache from `~/.cache`
* Old system journals
* Rotated log files

While generally safe for desktop systems, it is recommended to review the script and understand its actions before running on production servers or critical environments.

---

## Project Goals

Ghostwipe was created to provide a simple, reliable, and transparent maintenance utility for Linux users without introducing unnecessary complexity.

Key principles:

* Open source
* Easy to audit
* Lightweight
* Safe by default
* Automation-friendly
* PPA distributed for simple installation

---

## Contributing

Contributions, bug reports, feature requests, and pull requests are welcome.

Feel free to:

* Fork the repository
* Open issues
* Submit pull requests
* Suggest new maintenance features
* Improve compatibility across Linux distributions

Repository:

https://github.com/Daxxtropezz/ghostwipe

---

## Author

**Daxxtropezz**

GitHub:
https://github.com/Daxxtropezz

Launchpad:
https://launchpad.net/~daxxtropezz

---

## License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for details.

