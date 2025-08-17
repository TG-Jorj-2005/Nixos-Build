{config, lib, pkgs, ... }:
{
home.packages = with pkgs;[
 starship           # Prompt pentru terminal rapid și personalizabil
 fuzzel             # Application launcher pentru Wayland (alternativă la rofi/dmenu)
 polkit_gnome       # Agent de autentificare pentru aplicații ce necesită privilegii admin
 nitch              # System information tool minimal (neofetch alternativ)
 wlr-randr          # Utilitar pentru configurarea monitoarelor în Wayland
 wtype              # Tool pentru simularea tastării în Wayland
 swww               # Wallpaper daemon pentru Wayland - schimbă fundalul desktop-ului
 ffmpeg             # Suite de tools pentru procesarea video/audio
 wl-clipboard       # Utilities pentru clipboard în Wayland (wl-copy, wl-paste)
 hyprland-protocols # Protocoale Wayland specifice pentru Hyprland
 hyprpicker         # Color picker pentru Hyprland - selectează culori de pe ecran
 thunar             # File manager (din XFCE) - navigare prin fișiere
 swayidle           # Idle daemon - gestionează acțiuni când PC-ul e inactiv
 gtklock            # Screen locker pentru Wayland - blochează ecranul
 swaybg             # Background/wallpaper setter pentru Wayland
 xdg-desktop-portal-hyprland # Portal pentru integrarea aplicațiilor cu Hyprland
 wlsunset           # Blue light filter pentru Wayland - schimbă temperatura culorilor
 pyprland           # Plugin manager și extensii pentru Hyprland (scris în Python)
 pavucontrol        # PulseAudio Volume Control - interfață grafică pentru audio
 pamixer            # PulseAudio mixer din linia de comandă
 grim               # Screenshot utility pentru Wayland
 slurp              # Utilitar pentru selectarea unei zone de pe ecran (folosit cu grim)
];
}
