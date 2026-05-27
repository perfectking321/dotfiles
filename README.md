# Hyprland Dotfiles

My personal [Hyprland](https://hyprland.org/) configuration files.

## Structure

```
.config/hypr/
├── hyprland.conf          # Main Hyprland config
├── hypridle.conf          # Idle daemon config
├── confs/                 # Modular configs
│   ├── animations.conf
│   ├── keybinds.conf
│   ├── monitor.conf
│   ├── settings.conf
│   ├── startup.conf
│   ├── windowrules.conf
│   └── themes/            # Color themes (Catppuccin, Gruvbox, TokyoNight, etc.)
├── lockscreens/           # Hyprlock configs
├── scripts/               # Helper shell scripts
├── pypr/                  # Pyprland config
├── assets/                # Theme preview images
└── icons/                 # Notification/OSD icons
```

## Installation

```bash
git clone https://github.com/perfectking321/dotfiles.git ~/dotfiles
cp -r ~/dotfiles/.config/hypr ~/.config/hypr
```

> **Note:** Wallpapers and sounds are not included. Add your own to `~/.config/hypr/Wallpapers/` and `~/.config/hypr/sounds/`.
