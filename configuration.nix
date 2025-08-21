# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./assets/neovim.nix 
      ];

   
   #Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  #Home-Manager
  

 home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jorj = {
      # ⭐ TOATĂ CONFIGURAȚIA NEOVIM AICI ⭐
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        
        extraLuaConfig = ''
          -- Bootstrap lazy.nvim
          local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
          if not vim.loop.fs_stat(lazypath) then
            vim.fn.system({
              "git",
              "clone",
              "--filter=blob:none",
              "https://github.com/folke/lazy.nvim.git",
              "--branch=stable",
              lazypath,
            })
          end
          vim.opt.rtp:prepend(lazypath)

          vim.g.mapleader = " "
          vim.g.maplocalleader = "\\"

          require("lazy").setup({
            spec = {
              { "LazyVim/LazyVim", import = "lazyvim.plugins" },
              { import = "lazyvim.plugins.extras.coding.copilot" },
              { import = "lazyvim.plugins.extras.lang.typescript" },
              { import = "lazyvim.plugins.extras.lang.json" },
              { import = "lazyvim.plugins.extras.lang.python" },
            },
            defaults = {
              lazy = false,
              version = false,
            },
            checker = { enabled = true },
            performance = {
              rtp = {
                disabled_plugins = {
                  "gzip", "matchit", "matchparen", "netrwPlugin",
                  "tarPlugin", "tohtml", "tutor", "zipPlugin",
                },
              },
            },
          })
          require("lazyvim").setup()
        '';
      }; 



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
  security.sudo.wheelNeedsPassword = false;
   
  security.sudo.extraRules = [
    {
      users = [ "jorj" ];  # numele tău exact
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ]; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     wofi
     neovim
     dunst
     flameshot
     starship
     catppuccin-gtk
     catppuccin-kvantum
     catppuccin-cursors
     papirus-icon-theme
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
