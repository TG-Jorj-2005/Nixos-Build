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
    
    style = ''
      * {
        border: none;
        border-radius: 6;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background-color:transparent;
        border-radius: 10px;
        color: #ffffff;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #ffffff;
        border-radius: 5px;
      }

      #workspaces button:hover {
        background-color: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active {
        background-color: #64727d;
        color: #ffffff;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #network,
      #pulseaudio,
      #battery,
      #clock,
      #taskbar,
      #window {
        padding: 0 10px;
        margin: 0 2px;
        background-color: rgba(255, 255, 255, 0.1);
        border-radius: 5px;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.warning:not(.charging) {
        background-color: #ffa726;
        color: #000000;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #network.disconnected {
        background-color: #f53c3c;
      }

      #pulseaudio.muted {
        background-color: #90b1b1;
        color: #2a5c45;
      }
    '';
  };
}





