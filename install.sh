#!/bin/bash

#
# Hyprdots installer
# Author: gagarinten (modified by Gemini)
#

# --- Variables and Colors ---
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

# --- Core Functions ---
install() {
    if ! prompt_confirm "This will create symbolic links for hyprdots configurations in '$CONFIG_DIR'. Existing configurations will be backed up. Continue?"; then
        info "Installation cancelled by user."
        exit 0
    fi

    info "Starting Hyprdots installation using symbolic links..."
    
    local config_dirs=("hypr" "eww" "swaync" "swayosd" "walker")

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
    # This sed command makes the paths absolute to the repository's location
    # This ensures that no matter where you clone the repo, the paths inside the configs will be correct.
    if ! find "$SCRIPT_DIR/eww" -type f -name "*.yuck" -exec sed -i "s|/home/gagarinten/hyprdots|$SCRIPT_DIR|g" {} +; then
        error "Failed to update paths in eww configuration."
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
    local config_dirs=("hypr" "eww" "swaync" "swayosd" "walker")

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
