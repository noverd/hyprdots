#!/bin/bash

#
# Hyprdots installer

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/hyprdots_backup_$(date +%Y-%m-%d_%H-%M-%S)"

# Colors for output
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_CYAN='\033[0;36m'

# --- Helper Functions ---
info() {
    echo -e "${C_CYAN}[INFO]${C_RESET} $1"
}

success() {
    echo -e "${C_GREEN}[SUCCESS]${C_RESET} $1"
}

error() {
    echo -e "${C_RED}[ERROR]${C_RESET} $1"
    exit 1
}

warn() {
    echo -e "${C_YELLOW}[WARN]${C_RESET} $1"
}

prompt_confirm() {
    read -r -p "$(echo -e "${C_YELLOW}[CONFIRM]${C_RESET} $1 [y/N] ")" response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

detect_package_manager() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v emerge &>/dev/null; then
        echo "portage"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

install_packages() {
    local pm="$1"
    shift
    local packages=("$@")

    case "$pm" in
        pacman)
            sudo pacman -S --needed "${packages[@]}"
            ;;
        portage)
            # Map package names to Gentoo categories
            local gentoo_packages=()
            for pkg in "${packages[@]}"; do
                case "$pkg" in
                    hyprland)        gentoo_packages+=("gui-wm/hyprland") ;;
                    hypridle)        gentoo_packages+=("gui-apps/hypridle") ;;
                    hyprlock)        gentoo_packages+=("gui-apps/hyprlock") ;;
                    hyprsunset)      gentoo_packages+=("gui-apps/hyprsunset") ;;
                    hyprpaper)       gentoo_packages+=("gui-apps/hyprpaper") ;;
                    uwsm)            gentoo_packages+=("gui-apps/uwsm") ;;
                    walker)          gentoo_packages+=("gui-apps/walker") ;;
                    eww)             gentoo_packages+=("gui-apps/eww") ;;
                    swaync)          gentoo_packages+=("gui-apps/swaync") ;;
                    swayosd)         gentoo_packages+=("gui-apps/swayosd") ;;
                    bluez)           gentoo_packages+=("net-wireless/bluez") ;;
                    iproute2)        gentoo_packages+=("sys-apps/iproute2") ;;
                    jq)              gentoo_packages+=("app-misc/jq") ;;
                    socat)           gentoo_packages+=("net-analyzer/socat") ;;
                    playerctl)       gentoo_packages+=("media-sound/playerctl") ;;
                    pulseaudio-utils) gentoo_packages+=("media-sound/pulseaudio") ;;
                    *)               gentoo_packages+=("$pkg") ;;
                esac
            done
            sudo emerge --ask "${gentoo_packages[@]}"
            ;;
        apt)
            sudo apt install "${packages[@]}"
            ;;
        dnf)
            sudo dnf install "${packages[@]}"
            ;;
        zypper)
            sudo zypper install "${packages[@]}"
            ;;
        *)
            warn "Unknown package manager. Please install manually: ${packages[*]}"
            return 1
            ;;
    esac
}

check_dependencies() {
    local missing=()
    local deps=(
        "hyprland:hyprland"
        "hypridle:hypridle"
        "hyprlock:hyprlock"
        "hyprsunset:hyprsunset"
        "hyprpaper:hyprpaper"
        "uwsm:uwsm"
        "walker:walker"
        "eww:eww"
        "swaync:swaync"
        "swayosd:swayosd"
        "bluetoothctl:bluez"
        "ip:iproute2"
        "jq:jq"
        "socat:socat"
        "playerctl:playerctl"
        "pactl:pulseaudio-utils"
    )

    info "Checking dependencies..."
    for dep in "${deps[@]}"; do
        local cmd="${dep%%:*}"
        local pkg="${dep##*:}"
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$pkg")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        local pm
        pm=$(detect_package_manager)
        warn "Missing packages: ${missing[*]}"
        warn "Detected package manager: $pm"
        if prompt_confirm "Install missing packages?"; then
            install_packages "$pm" "${missing[@]}"
        else
            if ! prompt_confirm "Continue anyway?"; then
                exit 1
            fi
        fi
    else
        success "All dependencies are installed."
    fi
}

# --- Core Functions ---
install() {
    if ! prompt_confirm "This will create symbolic links for hyprdots configurations in '$CONFIG_DIR'. Existing configurations will be backed up. Continue?"; then
        info "Installation cancelled by user."
        exit 0
    fi

    check_dependencies

    info "Starting Hyprdots installation using symbolic links..."
    
    local config_dirs=("hypr" "eww" "swaync" "swayosd" "walker" "gtk-4.0" "kitty" "fastfetch")

    # Backup and link each directory
    for dir in "${config_dirs[@]}"; do
        local target_path="$CONFIG_DIR/$dir"
        local source_path="$SCRIPT_DIR/$dir"

        # Backup existing config if it's a real directory or file
        if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
             info "Backing up existing '$target_path'..."
             mkdir -p "$BACKUP_DIR"
             mv "$target_path" "$BACKUP_DIR/"
        fi
        
        # Remove if it's already a symlink or file to ensure a clean link
        if [ -e "$target_path" ] || [ -L "$target_path" ]; then
            info "Removing existing target at '$target_path'..."
            rm -rf "$target_path"
        fi

        info "Linking '$source_path' to '$target_path'..."
        ln -s "$source_path" "$target_path"
    done
    
    info "Updating dynamic paths in configuration files..."
    if ! find "$SCRIPT_DIR/eww" -type f -name "*.yuck" -exec sed -i "s|/home/gagarinten/hyprdots|$SCRIPT_DIR|g" {} +; then
        error "Failed to update paths in eww configuration."
    fi
    if ! sed -i "s|/home/gagarinten/hyprdots|$SCRIPT_DIR|g" "$SCRIPT_DIR/hypr/hyprlock.conf" 2>/dev/null; then
        warn "Could not update paths in hyprlock.conf"
    fi

    info "Setting script permissions..."
    chmod +x "$SCRIPT_DIR/scripts"/*.sh

    success "Installation complete! Hyprdots are now linked."
    info "Please log out and log back in for all changes to take effect."
}

uninstall() {
    if ! prompt_confirm "This will remove the Hyprdots symbolic links. Do you want to restore from the latest backup?"; then
        info "Uninstallation cancelled by user."
        exit 0
    fi

    info "Starting Hyprdots uninstallation..."
    local config_dirs=("hypr" "eww" "swaync" "swayosd" "walker" "ignis" "gtk-4.0" "kitty" "fastfetch")

    info "Removing symbolic links..."
    for dir in "${config_dirs[@]}"; do
        local target_path="$CONFIG_DIR/$dir"
        if [ -L "$target_path" ]; then
            info "Removing link '$target_path'..."
            rm "$target_path"
        fi
    done

    LATEST_BACKUP=$(find "$CONFIG_DIR" -maxdepth 1 -type d -name "hyprdots_backup_*" | sort -r | head -n 1)
    if [ -n "$LATEST_BACKUP" ] && prompt_confirm "Restore configurations from the latest backup '$LATEST_BACKUP'?"; then
        info "Restoring configurations from backup..."
        if ! cp -rT "$LATEST_BACKUP/" "$CONFIG_DIR/"; then
             error "Failed to restore from backup."
        fi
        success "Previous configurations have been restored."
        info "You may want to manually delete the backup directory: $LATEST_BACKUP"
    else
        info "Skipping backup restoration."
    fi

    success "Uninstallation complete."
}

# --- Main Logic ---
usage() {
    echo "Usage: $0 [--install | --uninstall]"
    exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi

case "$1" in
    --install)
        install
        ;;
    --uninstall)
        uninstall
        ;;
    *)
        usage
        ;;
esac
