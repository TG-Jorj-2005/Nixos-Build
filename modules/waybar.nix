{config, lib, pkgs, ...}:
{
  catppuccin.waybar.enable = true;
  programs.waybar = { 
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1" ];
        spacing = 4;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = [ "hyprland/workspaces" "wlr/taskbar" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "network" "pulseaudio" "battery" "clock" ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "💻";  # Terminal
            "2" = "🌐";  # Browser
            "3" = "⚡";  # Code/Development  
            "4" = "📁";  # Files/Explorer
            "5" = "🎵";  # Music/Media
            "6" = "🎮";  # Games/Entertainment
            "7" = "💬";  # Chat/Communication
            "8" = "📺";  # Video/Streaming
            "9" = "⚙️";  # Settings/System
            "10" = "📦"; # Miscellaneous
            default = "📋";
            active = "🔥";
            urgent = "🚨";          };
        };
        
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 14;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };
        
        "network" = {
          format-wifi = " 📶 {essid} ({signalStrength}%)";
          format-ethernet = " 🌐 {ipaddr}";
          format-disconnected = " 🔗 Disconnected";
          tooltip-format = " 📊 {ifname}: {ipaddr}/{cidr}";
        };
        
        "pulseaudio" = {
          format = "{icon} {volume}%";
         format-bluetooth = "🎧 {icon} {volume}%";
          format-bluetooth-muted = "🎧 🔇 Muted";
          format-muted = "🔇 Muted";
          format-source = "🎤 {volume}%";
          format-source-muted = "🎤❌";
          format-icons = {
            headphone = "🎧";
            hands-free = "📞";
            headset = "🎧";
            phone = "📱";
            portable = "🔊";
            car = "🚗";
            default = ["🔈" "🔉" "🔊"];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
	  };
        
        "battery" = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " ⚡ {capacity}%";
          format-plugged = " 🔌 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons =["🪫" "🔋" "🔋" "🔋" "🔋"];
	  tooltip-format = "{timeTo}, {capacity}%";
        };
        
        "clock" = {
          format = " 🕐 {:%H:%M}";
          format-alt = " 📅 {:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
      };
    };
    
}





