# Hyprdots

A set of functional, sharp-edged, and minimalistic dotfiles for Hyprland.

This configuration is built around a dark, high-contrast color scheme with bright accents, and a strict "no rounded corners" policy for a clean, uniform look.

## Color Palette

The color scheme is defined in `eww/eww.scss`:

-   **Backgrounds:** Dark grays (`#0a0a0a`, `#121212`)
-   **Foreground:** Light gray (`#e0e0e0`)
-   **Accent (Blue):** `#00d1ff`
-   **Accent (Green):** `#50fa7b`
-   **Accent (Red):** `#ff3838`
-   **Borders:** Medium gray (`#4a4a4a`)

## Dependencies

Before running the installation script, please ensure the following packages are installed on your system.

-   **Core Components:**
    -   `hyprland`
    -   `hypridle`
    -   `hyprlock`
-   **UI & Widgets:**
    -   `walker` (Application Launcher)
    -   `eww` (Elkowars Wacky Widgets)
    -   `swaync` (Sway Notification Center)
    -   `swayosd` (SwayOSD)
-   **Utilities:**
    -   `upower`
    -   `bluez` (provides `bluetoothctl`)
    -   `iproute2` (provides `ip`)
    -   `procps-ng` (provides `free`)
    -   `jq`
    -   `socat`
    -   `playerctl`
-   **Audio:**
    -   `pulseaudio-utils` (for `pactl`, may be provided by `pipewire-pulse` on PipeWire systems)
-   **Fonts:**
    -   A **Nerd Font** is required for icons to display correctly (e.g., *JetBrainsMono Nerd Font*).

## Installation & Management

This project uses a helper script to manage the configurations by creating symbolic links. This means any changes you make in this git repository will be reflected live on your system.

### How to Install

1.  **Clone the repository to a permanent location:**
    Because this method uses symbolic links, the cloned directory must not be deleted or moved after installation. A good place is `~/git/hyprdots`.
    ```bash
    git clone <repository-url> ~/git/hyprdots
    cd ~/git/hyprdots
    ```

2.  **Run the script with the `--install` flag:**
    The script will ask for confirmation, back up any existing configurations, and then create the necessary symbolic links.
    ```bash
    chmod +x install.sh
    ./install.sh --install
    ```

After the installation is complete, log out of your session and log back in to see the changes.

### How to Uninstall

To remove the symbolic links and restore your previous configuration from the backup, run:
```bash
./install.sh --uninstall
```

## Keybindings

The main modifier key is the **Super** key (Windows key). Here are some default keybindings:

| Keybinding              | Action                     |
| ----------------------- | -------------------------- |
| `SUPER + Q`             | Open Terminal              |
| `SUPER + E`             | Open File Manager          |
| `SUPER + W`             | Open Web Browser           |
| `SUPER + R`             | Open Application Menu      |
| `SUPER + C`             | Close Active Window        |
| `SUPER + F`             | Toggle Fullscreen          |
| `SUPER + V`             | Toggle Floating Window     |
| `SUPER + left/right/up/down` | Focus Window               |
| `SUPER + 1-9`           | Switch to Workspace        |
| `SUPER + SHIFT + 1-9`   | Move Window to Workspace   |
| `PrintScreen`           | Take Screenshot            |

Multimedia keys for volume, brightness, and player controls are also configured.
