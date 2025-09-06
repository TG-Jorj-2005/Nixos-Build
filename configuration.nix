# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ];

   
   #Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Greetd
    services.greetd = {
     enable = true;
      settings = {
       default_session = {
       command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'";
       user = "jorj";
      };
    };
   };
    #Console Theme
    console = {
    # Font pentru consola
    font = "Lat2-Terminus16";
    keyMap = "us"; # sau "ro"
    
    # Culori pentru TTY (schema de culori întunecată)
    colors = [
      "2e3440"  # black
      "bf616a"  # red  
      "a3be8c"  # green
      "ebcb8b"  # yellow
      "81a1c1"  # blue
      "b48ead"  # magenta
      "88c0d0"  # cyan
      "e5e9f0"  # white
      "4c566a"  # bright black
      "bf616a"  # bright red
      "a3be8c"  # bright green
      "ebcb8b"  # bright yellow
      "81a1c1"  # bright blue
      "b48ead"  # bright magenta
      "8fbcbb"  # bright cyan
      "eceff4"  # bright white
    ];
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Nixos-JRJ-BRW"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";

  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jorj = {
    isNormalUser = true;
    description = "Tanase George";
    extraGroups = [ "networkmanager" "users" "wheel" "audio" "video" ];
    packages = with pkgs; [];
  };
  # Sa nu mai am nevoie de parola la sudo
  security.sudo.wheelNeedsPassword = false;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #Agent Autentificare
  security.polkit ={
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (subject.isInGroup("users") && subject.local && subject.active) {
              return polkit.Result.YES;
          }
      });
    '';
    };
  systemd.services.polkit.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #Icons packages
   fonts.packages = with pkgs; [                                                                          
    noto-fonts                                                                                           
    noto-fonts-cjk-sans                                                                                       
    noto-fonts-emoji                                                                                     
    liberation_ttf
    nerd-fonts.lilex
    roboto-mono
    font-awesome
  ];
  #Pachete
  environment.systemPackages = with pkgs; [
     lxqt.lxqt-policykit
     neovim
     dunst
     zathura
     pkg-config
     raylib
    raygui
    gcc
    cmake
    pkg-config
    gdb
    valgrind
  ];

  #OpenGL activat
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true; # pentru aplicații 32-bit
  };
   #Hyprland
   programs.hyprland = {
     enable = true;
     xwayland.enable = true;
      };
   xdg = {
     portal = {
       enable = true;
       extraPortals = [pkgs.xdg-desktop-portal-gtk ];
         };  
      };

  #Configuratii: 
     programs.git = {
    enable = true;
    config = {
      user = {
        name = "TG-Jorj-2005";
        email = "tanase.george.1905@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  system.stateVersion = "25.05"; # Did you read the comment?
  #Auto Update and garbage collect
  system ={
    autoUpgrade={
      enable = true;
      dates = "weekly";
      };
     };
   nix = {
      gc= {
       automatic = true;
       dates = "daily";
       options = "--delete-older-than 10d";

        };
	settings.auto-optimise-store = true;
      };

  #Sound
   security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
    #Bluetooth    
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.bluetooth.package = pkgs.bluez;
   #Ollama
    services.ollama = {
              enable = true;
              acceleration = "cuda"; # sau "rocm" / "none"
            };

            systemd.services."ollama-pull-dolphin" = {
              description = "Pull Dolphin Mistral model";
              after = [ "ollama.service" ];
              wants = [ "ollama.service" ];
              serviceConfig = {
                ExecStart = "${pkgs.ollama}/bin/ollama pull dolphin-mistral:latest";
                User = "jorj";
              };
              wantedBy = [ "multi-user.target" ];
            };
}
