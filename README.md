# Hyprland Dotfiles

My personal [Hyprland](https://hyprland.org/) configuration files.

## Structure

```
.config/
├── hypr/
│   ├── hyprland.conf          # Main Hyprland config
│   ├── hypridle.conf          # Idle daemon config
│   ├── hyprlock.conf          # Lock screen config
│   ├── confs/                 # Modular configs
│   │   ├── animations.conf
│   │   ├── keybinds.conf
│   │   ├── monitor.conf
│   │   ├── settings.conf
│   │   ├── startup.conf
│   │   ├── windowrules.conf
│   │   └── themes/            # Color themes (Catppuccin, Gruvbox, TokyoNight, etc.)
│   ├── lockscreens/           # Hyprlock configs
│   ├── scripts/               # Helper shell scripts
│   ├── pypr/                  # Pyprland config
│   ├── assets/                # Theme preview images
│   └── icons/                 # Notification/OSD icons
└── waypaper/
    ├── config.ini             # Waypaper wallpaper manager config
    └── style.css              # Custom GTK styling for Waypaper

sddm/
├── conf.d/                    # SDDM config files (copy to /etc/sddm.conf.d/)
│   ├── performance.conf
│   ├── theme.conf
│   ├── theme.conf.user        # Sets active theme to SilentSDDM
│   └── virtualkbd.conf
└── themes/
    └── SilentSDDM/            # Login screen theme (copy to /usr/share/sddm/themes/)
```

## Installation

```bash
git clone https://github.com/perfectking321/dotfiles.git ~/dotfiles
```

### Hyprland + Hyprlock

```bash
cp -r ~/dotfiles/.config/hypr ~/.config/hypr
```

### Waypaper (Wallpaper Manager)

```bash
mkdir -p ~/.config/waypaper
cp ~/dotfiles/.config/waypaper/* ~/.config/waypaper/
```

> Install waypaper and mpvpaper: `yay -S waypaper mpvpaper`

### SDDM (Display Manager) + SilentSDDM Theme

```bash
# Install the theme
sudo cp -r ~/dotfiles/sddm/themes/SilentSDDM /usr/share/sddm/themes/

# Apply SDDM config
sudo cp ~/dotfiles/sddm/conf.d/* /etc/sddm.conf.d/

# Enable SDDM
sudo systemctl enable sddm
```

> **Note:** Wallpapers and sounds are not included. Add your own to `~/.config/hypr/Wallpapers/` and `~/.config/hypr/sounds/`.
