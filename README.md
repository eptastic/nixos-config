# 🐧 My NixOS Configuration

This is my personal, fully declarative NixOS configuration. It uses [flakes](https://nixos.wiki/wiki/Flakes), [home-manager](https://github.com/nix-community/home-manager), and custom modules to manage the OS, user environment, and window manager (Hyprland).

## 🧩 Structure
```
├── assets 
├── flake.lock
├── flake.nix
├── hosts
└── modules
```

## 🚀 Features

- ❄️ Fully declarative flake-based setup
- 🏠 Home-manager integrated as a NixOS module
- 🧠 Custom modules for software, fonts, and hardware quirks
- 🛠️ Tooling: neovim, git, zsh
- 🔐 Secrets management with sops-nix

## To-Do

- Introduce option flags

