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

## Requirements

- [Quickshell](https://quickshell.outfoxxed.me/) (built for Quickshell 0.3.1)
- [Hyprland](https://hyprland.org/) 0.56+
- `awww` and `awww-daemon` (for hyprquickpaper)
- `magick` / ImageMagick (for thumbnail caching)
- `Barlow Medium` font (for widget text)
