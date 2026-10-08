# Rebuild baseline

Validated against the clean BSPWM VM on 2026-10-07.

## Package manifests

- `packages/pacman.txt`: hardware-independent native packages used by the desktop.
- `packages/aur.txt`: AUR packages to install after bootstrapping yay.
- `packages/hardware.txt`: reference hardware/VM packages. Do not install every block blindly.

Debug split packages such as `*-debug` are intentionally excluded.

## Extra setup required by the validated environment

- pyenv Python 3.13.2
- pip packages: psutil, gputil, pyamdgpuinfo, setuptools
- pipx Pawlette from https://github.com/meowrch/pawlette
- sddm-astronaut-theme from https://github.com/Keyitdev/sddm-astronaut-theme
- SDDM snippets under `system/etc/sddm.conf.d/`

The wallpaper data under `~/.local/share/wallpapers` is runtime/user data and is not currently versioned in this repository.

## Deskflow SDDM + BSPWM with TLS

- The package manifest installs `deskflow` from Arch Extra.
- `install.sh` installs the SDDM system service, watcher, BSPWM user service,
  and `.xprofile` when no existing `.xprofile` needs preserving.
- Services are **not** activated until the Windows server fingerprint and both
  Arch certificates are configured locally.
- Follow [docs/DESKFLOW.md](docs/DESKFLOW.md) and run
  `bash scripts/setup-deskflow.sh prepare ...`, then `activate`.
- Never commit `~/.config/Deskflow`, `/var/lib/sddm/.config/Deskflow`, PEMs,
  TLS private keys, or trusted-client/servers files.
