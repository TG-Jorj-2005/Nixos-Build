{config, lib, pkgs, ... }:
{

home.packages = with pkgs;[
 starship
 fuzzel
 polkit_gnome
 wlr-randr
 wtype
 swww
 ffmpeg
 wl-clipboard
 hyprland-protocols
 hyprpicker
 swayidle
 gtklock
 swaybg
 xdg-desktop-portal-hyprland
 wlsunset
 pyprland
 pavucontrol
 pamixer
 grim
 slurp
];





}
