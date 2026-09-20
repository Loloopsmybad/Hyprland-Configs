# Hyprland Configs

Custom Quickshell widgets and utilities for Hyprland.

## Contents

### liquidglass Widgets

Frosted glass-style desktop widgets using Hyprland's blur layer effect.

| Widget | Description |
|--------|-------------|
| clockAnalog | Analog clock with second ring |
| clockDigital | Digital time with date |
| clockWorld | World clock (multiple timezones) |
| music | Media player info |
| weather | Weather display |
| calendar | Calendar view |
| timer | Countdown/stopwatch |

### hyprquickpaper

Wallpaper picker launched with `Super+W`. Horizontal dock-style tile picker
with zoom effect, keyboard navigation, and wallpaper switching via `awww`.

**Requirements:** `awww`, `awww-daemon`, `magick` (ImageMagick)

## Installation

```bash
bash install.sh
```

Interactive installer — select what to install:

```
What do you want to install?
  1) liquidglass widgets
  2) hyprquickpaper wallpaper picker
  3) Both
  a) All
  Enter = cancel
```

### Manual Install

**Widgets:**
```bash
cp -r widgets components fonts icons shell.qml ~/.config/quickshell/liquidglass/
```

**hyprquickpaper:**
```bash
cp -r hyprquickpaper ~/.config/quickshell/
```

### Auto-start

Add to `~/.config/hypr/hyprland/execs.lua`:

```lua
hl.exec_cmd("sleep 2 && qs -c liquidglass -d")
hl.exec_cmd("sleep 2 && qs -c hyprquickpaper -d")
```

## Configuration

### Widgets

Position and size are hardcoded in `shell.qml`. Edit the `posX`, `posY`,
`widgetWidth`, `widgetHeight` properties for each widget.

### hyprquickpaper

Config: `~/.config/quickshell/hyprquickpaper/config.json`

| Key | Default | Description |
|-----|---------|-------------|
| `wallpaper_path` | `~/Pictures/Wallpapers` | Wallpaper directory |
| `cache_path` | `~/.cache/quickshell/hyprquickpaper/` | Thumbnail cache |
| `number_of_pictures` | `6` | Visible tiles |
| `height` | `500` | Tile height (px) |
| `border_color` | `#a7c080` | Selected border color |

## Credits

### liquidglass Widgets

Original widgets by [notashelf](https://github.com/notashelf/liquidglass-hyprland).
Ported to Quickshell for Hyprland with modifications.

### hyprquickpaper

Based on the quickshell wallpaper picker concept. Modified with dock-style
tile effect and `awww` integration.

### hyprlock

Screen locker using [hyprlock](https://github.com/hyprwm/hyprlock). Comes with
multiple layout options and helper scripts for media, battery, weather, and
notification display.

**Layouts:** `layout1` through `layout20` in `my_configs/hyprlock/layouts/`.

To switch layout, edit `~/.config/hypr/hyprlock.conf`:

```conf
# comment out the current layout
# source = $hyprlockDir/layouts/layout5.conf
# uncomment the one you want
source = $hyprlockDir/layouts/layout13.conf
```

**Manual Install:**
```bash
cp my_configs/hyprlock/hyprlock.conf ~/.config/hypr/
cp -r my_configs/hyprlock/layouts ~/.config/hyprlock/
cp -r my_configs/hyprlock/scripts ~/.config/hyprlock/
cp my_configs/hyprlock/colors.conf ~/.config/hyprlock/
```

**Keybind:** `Super+L` triggers hyprlock (configured in `~/.config/caelestia/hypr-user.lua`).

### SDDM Theme (forest)

SDDM login screen theme from [qylock](https://github.com/Darkkal44/qylock).

**Manual Install:**
```bash
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r my_configs/sddm/forest /usr/share/sddm/themes/forest
echo -e "[Theme]\nCurrent=forest" | sudo tee /etc/sddm.conf.d/theme.conf
```

Restart SDDM or reboot to apply.

**Note:** The `bg.mp4` video file (51MB) is not included in this repo. Download it
from the [qylock themes repo](https://github.com/Darkkal44/qylock) and place it
in the theme directory.

## Requirements

- [Quickshell](https://quickshell.outfoxxed.me/) (built for Quickshell 0.3.1)
- [Hyprland](https://hyprland.org/) 0.56+
- [hyprlock](https://github.com/hyprwm/hyprlock) (for screen locking)
- SDDM (for login screen theme)
- `awww` and `awww-daemon` (for hyprquickpaper)
- `magick` / ImageMagick (for thumbnail caching)
- `Barlow Medium` font (for widget text)
