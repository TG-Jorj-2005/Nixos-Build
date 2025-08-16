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
       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'";
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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     wofi
     neovim
     ghostty
     dunst
     flameshot
     starship
     unzip
     git
     pyprland
     brave
     waybar
     rofi-wayland
  ];
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
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
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

}
