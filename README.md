<div align="center">

# ghostwipe

<p>
  <img src="assets/logo.png" alt="Ghostwipe Logo" width="200">
</p>

<p><strong>Cross-Platform Maintenance & Cleanup Utility for Linux and macOS</strong></p>

<p>
  <img src="https://img.shields.io/badge/version-2.1.0-blue.svg">
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20macOS-orange.svg">
  <img src="https://img.shields.io/badge/package-APT%20%7C%20Homebrew-informational.svg">
  <img src="https://img.shields.io/badge/license-MIT-blue.svg">
  <img src="https://img.shields.io/badge/status-active-success.svg">
</p>

*A lightweight, transparent, and safety-focused maintenance utility for Debian/Ubuntu Linux and macOS.*

</div>

---

## Overview

`ghostwipe` is an open-source system maintenance utility that provides one consistent CLI for routine cleanup and package maintenance across **Debian/Ubuntu Linux** and **macOS**.

Ghostwipe automatically detects the host operating system and uses the appropriate platform backend:

| Platform | Package Backend | Cleanup Behavior |
| --- | --- | --- |
| Debian / Ubuntu Linux | APT | APT cleanup, age-bounded `/tmp` and `/var/tmp` cleanup, user cache cleanup, systemd journal vacuum |
| macOS | Homebrew | Homebrew cleanup, per-user temporary-directory cleanup, `~/Library/Caches` cleanup |
| Other operating systems | — | Not supported |

On macOS, Ghostwipe intentionally leaves unified/system logs to macOS instead of force-deleting them.

---

## Preview

<p align="center">
  <img src="assets/screenshot-1.png" alt="Ghostwipe Screenshot 1" width="500">
  <img src="assets/screenshot-2.png" alt="Ghostwipe Screenshot 2" width="500">
</p>

---

## Features

- Interactive terminal menu
- Direct command-line subcommands
- Automatic Linux/macOS detection
- APT support on Debian/Ubuntu
- Homebrew support on macOS
- Safe and deep cleanup modes
- Age-bounded temporary-file cleanup
- Age-bounded user-cache cleanup
- `--dry-run` preview mode
- Explicit confirmation for deep cleanup
- Persistent per-user logging
- `doctor` diagnostics command
- Optional `figlet`, `lolcat`, `fastfetch`, or `neofetch` integration
- Architecture reporting for Intel/AMD and ARM systems

### Safety Improvements in v2.1.0

Ghostwipe no longer blindly performs operations such as:

```bash
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf ~/.cache/*
find /var/log -name "*.log*" -delete
```

Instead, cleanup is bounded by file age and platform-specific directories. Ghostwipe does not manually erase `/var/log` and does not clear macOS unified logs.

---

## Supported Platforms

| Platform | Architecture | Supported |
| --- | --- | :---: |
| Ubuntu / Debian Linux | x86_64 / amd64 | ✅ |
| Ubuntu / Debian Linux | arm64 / aarch64 | ✅ |
| macOS | Intel x86_64 | ✅ |
| macOS | Apple Silicon arm64 | ✅ |

### Linux Requirements

- Debian or Ubuntu
- `apt-get`
- `sudo` for system-level maintenance unless already running as root
- systemd `journalctl` is optional; journal cleanup is skipped if unavailable

### macOS Requirements

- macOS
- Homebrew

Homebrew commands are never executed with `sudo`.

---

## Installation

### macOS — Homebrew

Install Ghostwipe from the official tap:

```bash
brew install Daxxtropezz/tap/ghostwipe
```

Then verify:

```bash
ghostwipe --version
ghostwipe doctor
```

The Homebrew formula depends on a modern Bash version and supports both Intel and Apple Silicon Macs.

---

### Linux — Homebrew

If you use Homebrew on Linux, the same formula can be installed with:

```bash
brew install Daxxtropezz/tap/ghostwipe
```

Ghostwipe will still use **APT** for operating-system package maintenance, so Linux operational support currently requires Debian/Ubuntu even when the Ghostwipe executable itself is installed through Homebrew.

---

### Ubuntu — Launchpad PPA

Install through the official PPA:

```bash
sudo add-apt-repository ppa:daxxtropezz/ghostwipe
sudo apt update
sudo apt install ghostwipe
```

---

### Manual Installation

Clone the repository:

```bash
git clone https://github.com/Daxxtropezz/ghostwipe.git
cd ghostwipe
chmod +x ghostwipe
```

Install system-wide:

```bash
sudo install -m 755 ghostwipe /usr/local/bin/ghostwipe
```

On macOS, **Homebrew installation is recommended** so that a modern Bash dependency is provided automatically.

---

## Usage

Launch the interactive menu:

```bash
ghostwipe
```

Update packages:

```bash
ghostwipe update
```

On Linux this runs APT maintenance. On macOS this runs Homebrew update/upgrade/cleanup.

Perform safe cleanup:

```bash
ghostwipe clean
```

Preview it first:

```bash
ghostwipe --dry-run clean
```

Perform deep cleanup:

```bash
ghostwipe deep-clean
```

Deep cleanup requires typing `WIPE`. For automation:

```bash
ghostwipe --yes deep-clean
```

Preview deep cleanup without changing the system:

```bash
ghostwipe --dry-run deep-clean
```

Run package maintenance followed by safe cleanup:

```bash
ghostwipe full
```

Display system information:

```bash
ghostwipe info
```

Run diagnostics:

```bash
ghostwipe doctor
```

Show recent Ghostwipe log entries:

```bash
ghostwipe log
```

Show version:

```bash
ghostwipe --version
```

Show help:

```bash
ghostwipe --help
```

---

## Command Reference

| Command | Description |
| --- | --- |
| `ghostwipe` | Launch interactive mode |
| `ghostwipe update` | Update packages using APT or Homebrew |
| `ghostwipe clean` | Perform safe cleanup |
| `ghostwipe deep-clean` | Perform deeper age-bounded cleanup |
| `ghostwipe full` | Run package update followed by safe cleanup |
| `ghostwipe info` | Display system information |
| `ghostwipe doctor` | Validate required platform dependencies |
| `ghostwipe log` | Show the latest Ghostwipe log entries |
| `ghostwipe version` | Show installed version |
| `ghostwipe help` | Show help |
| `ghostwipe --dry-run <command>` | Preview supported actions |
| `ghostwipe -y deep-clean` | Skip deep-clean confirmation |
| `ghostwipe --yes deep-clean` | Skip deep-clean confirmation |
| `ghostwipe -h`, `--help` | Show help |
| `ghostwipe -v`, `--version` | Show version |

---

## Cleanup Behavior

### Safe Cleanup

**Linux**

- Removes regular files older than 7 days from `/tmp` and `/var/tmp`
- Runs `apt-get autoremove`
- Cleans the APT cache
- Removes user cache files older than 30 days
- Vacuums systemd journal entries older than 7 days when `journalctl` is available

**macOS**

- Removes files older than 7 days from the current user's macOS temporary directory
- Runs `brew cleanup --prune=7`
- Removes files older than 30 days from `~/Library/Caches`
- Does not manually erase macOS unified/system logs

### Deep Cleanup

Deep cleanup is more aggressive but remains bounded.

**Linux**

- Removes regular files older than 1 day from `/tmp` and `/var/tmp`
- Removes unused APT dependencies and cleans package cache
- Removes user cache files older than 7 days
- Vacuums systemd journal entries older than 1 day when available

**macOS**

- Removes files older than 1 day from the current user's macOS temporary directory
- Runs `brew cleanup --prune=1`
- Removes files older than 7 days from `~/Library/Caches`
- Does not manually erase macOS unified/system logs

---

## Logs

Ghostwipe records its own activity in a per-user state directory.

On Linux:

```text
~/.local/state/ghostwipe/ghostwipe.log
```

On macOS:

```text
~/Library/Application Support/Ghostwipe/ghostwipe.log
```

If the normal state directory cannot be created, Ghostwipe falls back to the user's temporary directory.

View recent entries with:

```bash
ghostwipe log
```

---

## Dry Run

Before performing cleanup, you can inspect what Ghostwipe intends to do:

```bash
ghostwipe --dry-run clean
ghostwipe --dry-run deep-clean
```

Package manager commands are printed instead of executed in dry-run mode. Files targeted by cleanup are listed without being deleted.

---

## Safety Notice

Ghostwipe is designed to be safer than a blanket cleanup script, but cleanup utilities can still remove data applications expect to cache temporarily.

For important servers, development machines, or production systems:

- run `ghostwipe --dry-run clean` first;
- review the listed files;
- avoid unattended deep cleanup until you understand its behavior;
- keep normal backups and recovery procedures.

Ghostwipe does not replace operating-system lifecycle management, monitoring, backups, or vendor-specific maintenance tools.

---

## Repository Structure

```text
ghostwipe/
├── ghostwipe
├── README.md
├── LICENSE
├── .gitignore
├── assets/
└── debian/
    ├── changelog
    ├── control
    ├── copyright
    ├── install
    ├── rules
    └── source/
        └── format
```

The Homebrew formula lives in the separate tap repository:

```text
homebrew-tap/
└── Formula/
    ├── ztk.rb
    └── ghostwipe.rb
```

---

## Project Goals

Ghostwipe aims to remain:

- Open source
- Easy to audit
- Lightweight
- Safe by default
- Automation-friendly
- Cross-platform where behavior can be implemented safely
- Distributed through native or familiar package channels

---

## Contributing

Contributions, bug reports, feature requests, and pull requests are welcome.

Repository:

https://github.com/Daxxtropezz/ghostwipe

---

## Author

**Daxxtropezz**

GitHub: https://github.com/Daxxtropezz

Launchpad: https://launchpad.net/~daxxtropezz

---

## License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for details.
