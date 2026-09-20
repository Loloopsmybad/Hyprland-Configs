#!/bin/bash
# Install Hyprland configs (widgets + hyprquickpaper)
# Run: bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
QS_DIR="$HOME/.config/quickshell"

echo "Hyprland Configs Installer"
echo ""

# --- detect what's installed ---
WIDGETS=false
if [ -d "$QS_DIR/liquidglass" ]; then
    WIDGETS=true
fi

QUICKPAPER=false
if [ -d "$QS_DIR/hyprquickpaper" ]; then
    QUICKPAPER=true
fi

echo "Currently installed:"
echo "  1) liquidglass widgets   [ $([ "$WIDGETS" = true ] && echo installed || echo not installed) ]"
echo "  2) hyprquickpaper        [ $([ "$QUICKPAPER" = true ] && echo installed || echo not installed) ]"
echo ""

# --- prompt ---
while :; do
    read -rp "What do you want to install? (numbers, e.g. '1 2'; 'a' = all; Enter = cancel) > " choice
    if [ -z "$choice" ]; then
        echo "Nothing installed."
        exit 0
    fi
    if [ "$choice" = "a" ]; then
        sel="1 2"
    else
        sel="$(echo "$choice" | tr ',' ' ')"
    fi
    valid=1
    for c in $sel; do
        case "$c" in
            1 | 2) ;;
            *) valid=0 ;;
        esac
    done
    if [ "$valid" = 1 ]; then
        break
    fi
    echo "Invalid selection: pick 1, 2 (or 'a')."
done

# --- install ---
for c in $sel; do
    if [ "$c" = "1" ]; then
        echo ""
        echo "Installing liquidglass widgets..."
        mkdir -p "$QS_DIR/liquidglass"
        cp -r "$REPO_DIR/widgets" "$QS_DIR/liquidglass/"
        cp -r "$REPO_DIR/components" "$QS_DIR/liquidglass/"
        cp -r "$REPO_DIR/fonts" "$QS_DIR/liquidglass/"
        cp -r "$REPO_DIR/icons" "$QS_DIR/liquidglass/"
        cp "$REPO_DIR/shell.qml" "$QS_DIR/liquidglass/"
        echo "  Installed to $QS_DIR/liquidglass/"
    fi

    if [ "$c" = "2" ]; then
        echo ""
        echo "Installing hyprquickpaper..."
        mkdir -p "$QS_DIR/hyprquickpaper"
        cp -r "$REPO_DIR/hyprquickpaper/"* "$QS_DIR/hyprquickpaper/"
        chmod +x "$QS_DIR/hyprquickpaper/commands.sh" 2>/dev/null || true
        chmod +x "$QS_DIR/hyprquickpaper/cache.sh" 2>/dev/null || true
        chmod +x "$QS_DIR/hyprquickpaper/scripts/"*.sh 2>/dev/null || true
        echo "  Installed to $QS_DIR/hyprquickpaper/"
    fi
done

echo ""
echo "Done! Start with:"
echo "  qs -c liquidglass -d &"
echo "  qs -c hyprquickpaper -d &"
echo ""
echo "Or add to ~/.config/hypr/hyprland/execs.lua for auto-start."
