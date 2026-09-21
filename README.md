<p align="center">
  <img src="https://img.shields.io/badge/Hyprland-88c0d0?style=for-the-badge&logo=hyprland&logoColor=white" />
  <img src="https://img.shields.io/badge/Quickshell-5e81ac?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyQzYuNDggMiAyIDYuNDggMiAxMnM0LjQ4IDEwIDEwIDEwIDEwLTQuNDggMTAtMTBTMTcuNTIgMiAxMiAyeiIvPjwvc3ZnPg==" />
  <img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
</p>

<h1 align="center">Hyprland Configs</h1>

<p align="center">
  Custom <b>Quickshell widgets</b>, <b>hyprlock themes</b>, and <b>wallpaper tools</b> for Hyprland.<br/>
  Built for <code>Caelestia</code> shell on <code>Quickshell 0.3.1+</code>
</p>

---

## <img src="https://cdn-icons-png.flaticon.com/512/3658/3658695.png" width="20"/> What's Inside

<table>
<tr>
<td width="50%">

### `liquidglass` Widgets
> Frosted glass desktop widgets with blur layer effects

| Widget | What it does |
|--------|-------------|
| `clockAnalog` | Analog clock with second ring |
| `clockDigital` | Digital time + date |
| `clockWorld` | Multi-timezone world clock |
| `music` | Now playing info |
| `weather` | Live weather display |
| `calendar` | Calendar view |
| `timer` | Countdown / stopwatch |

</td>
<td width="50%">

### `hyprquickpaper`
> Dock-style wallpaper picker (`Super+W`)

- Horizontal tile picker with zoom
- Keyboard navigation
- Thumbnail caching via ImageMagick

**Requires:** `awww`, `awww-daemon`, `magick`

</td>
</tr>
</table>

---

## <img src="https://cdn-icons-png.flaticon.com/512/2991/2991148.png" width="20"/> hyprlock

Screen locker with multiple layouts + **video background support**.

### Layouts

| Layout | Style |
|--------|-------|
| `layout1` - `layout17` | Static wallpaper backgrounds |
| [`layout_video`](my_configs/hyprlock/layouts/layout_video.conf) | **Video background** via `mpvpaper` |

### Video Background Setup

> Uses [`mpvpaper`](https://github.com/GhostNaN/mpvpaper) to play a video behind a transparent hyprlock screen.

**How it works:**
1. `mpvpaper` renders video fullscreen on a background layer
2. `hyprlock` sits on top with a transparent background
3. On unlock/sleep, `mpvpaper` is killed to free resources

**Files involved:**

| File | Purpose |
|------|---------|
| `layout_video.conf` | hyprlock layout with transparent `background` |
| `hypridle.conf` | Starts/stops mpvpaper on idle + suspend |
| `hypr-user.lua` | `Super+L` triggers mpvpaper + hyprlock |
| `wlogout/layout` | Lock button in power menu uses video bg |

**Quick setup:**
```bash
# Place your video
cp ~/my-video.mp4 ~/Wallpapers/Video/background.mp4

# Copy configs
cp my_configs/hyprlock/layouts/layout_video.conf ~/.config/hyprlock/layouts/
cp my_configs/hypr/hypridle.conf ~/.config/hypr/
cp my_configs/caelestia/hypr-user.lua ~/.config/caelestia/
cp my_configs/wlogout/layout ~/.config/wlogout/

# Reload
hyprctl reload
```

> **Tip:** Edit the video path in `hypridle.conf`, `hypr-user.lua`, and `wlogout/layout` to point to your file.

---

## <img src="https://cdn-icons-png.flaticon.com/512/3135/3135783.png" width="20"/> SDDM Theme

> `forest` login screen from [qylock](https://github.com/Darkkal44/qylock)

```bash
sudo mkdir -p /usr/share/sddm/themes
sudo cp -r my_configs/sddm/forest /usr/share/sddm/themes/forest
echo -e "[Theme]\nCurrent=forest" | sudo tee /etc/sddm.conf.d/theme.conf
```

> The `bg.mp4` video (51MB) is not in this repo. Grab it from the [qylock repo](https://github.com/Darkkal44/qylock).

---

## <img src="https://cdn-icons-png.flaticon.com/512/2885/2885417.png" width="20"/> Install

```bash
bash install.sh
```

```
What do you want to install?
  1) liquidglass widgets
  2) hyprquickpaper wallpaper picker
  3) Both
  a) All
  Enter = cancel
```

### Manual

**Widgets:**
```bash
cp -r widgets components fonts icons shell.qml ~/.config/quickshell/liquidglass/
```

**hyprquickpaper:**
```bash
cp -r hyprquickpaper ~/.config/quickshell/
```

**hyprlock:**
```bash
cp my_configs/hyprlock/hyprlock.conf ~/.config/hypr/
cp -r my_configs/hyprlock/layouts ~/.config/hyprlock/
cp -r my_configs/hyprlock/scripts ~/.config/hyprlock/
cp my_configs/hyprlock/colors.conf ~/.config/hyprlock/
```

**Auto-start** — add to `~/.config/hypr/hyprland/execs.lua`:
```lua
hl.exec_cmd("sleep 2 && qs -c liquidglass -d")
hl.exec_cmd("sleep 2 && qs -c hyprquickpaper -d")
```

---

## <img src="https://cdn-icons-png.flaticon.com/512/1827/1827421.png" width="20"/> Configuration

<details>
<summary><b>Widgets</b></summary>

Position/size hardcoded in `shell.qml`. Edit `posX`, `posY`, `widgetWidth`, `widgetHeight` per widget.

</details>

<details>
<summary><b>hyprquickpaper</b></summary>

Config: `~/.config/quickshell/hyprquickpaper/config.json`

| Key | Default | Description |
|-----|---------|-------------|
| `wallpaper_path` | `~/Pictures/Wallpapers` | Wallpaper dir |
| `cache_path` | `~/.cache/quickshell/hyprquickpaper/` | Thumbnail cache |
| `number_of_pictures` | `6` | Visible tiles |
| `height` | `500` | Tile height (px) |
| `border_color` | `#a7c080` | Selected border |

</details>

<details>
<summary><b>hyprlock</b></summary>

Switch layout in `~/.config/hypr/hyprlock.conf`:
```conf
# comment current
# source = $hyprlockDir/layouts/layout5.conf
# uncomment desired
source = $hyprlockDir/layouts/layout_video.conf
```

</details>

---

## <img src="https://cdn-icons-png.flaticon.com/512/4474/4474585.png" width="20"/> Requirements

| Dependency | For |
|------------|-----|
| [Quickshell](https://quickshell.outfoxxed.me/) `0.3.1+` | Widgets |
| [Hyprland](https://hyprland.org/) `0.56+` | Compositor |
| [hyprlock](https://github.com/hyprwm/hyprlock) | Screen locking |
| [mpvpaper](https://github.com/GhostNaN/mpvpaper) | Video backgrounds |
| SDDM | Login screen theme |
| `awww` + `awww-daemon` | hyprquickpaper |
| `magick` / ImageMagick | Thumbnail caching |
| `Barlow Medium` | Widget font |

---

## <img src="https://cdn-icons-png.flaticon.com/512/1169/1169331.png" width="20"/> Credits

| Project | Author |
|---------|--------|
| [liquidglass](https://github.com/notashelf/liquidglass-hyprland) | [notashelf](https://github.com/notashelf) |
| [hyprquickpaper](https://github.com/) | Quickshell wallpaper picker concept |
| [hyprlock](https://github.com/hyprwm/hyprlock) | Hyprland screen locker |
| [mpvpaper](https://github.com/GhostNaN/mpvpaper) | Video background renderer |
| [qylock](https://github.com/Darkkal44/qylock) | SDDM forest theme |

---

<p align="center">
  <sub>Made with <code>love</code> for <a href="https://hyprland.org/">Hyprland</a></sub>
</p>
