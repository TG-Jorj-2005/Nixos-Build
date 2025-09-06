{ inputs, config, pkgs, lib, ... }:

{
  imports = [ ./modules/sh.nix
              ./modules/hyprland.nix
	      ./modules/git.nix
	      ./modules/starhip.nix
	      ./modules/waybar.nix
	      ./assets/neovim.nix
	      ./modules/rofi.nix
	      ./modules/alacritty.nix
	      ./modules/rust.nix 
        ./modules/vscode.nix
		       ];


 home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

   theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      name = "Sans";
      size = 12;
    };
  };

  qt={
  enable = true;
  platformTheme.name = "gtk";
  style = {
    name = "gtk2"; 
   };
  };

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jorj";
  home.homeDirectory = "/home/jorj";

  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    brave
    curl
    wget
    git
    unzip
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code  
    nerd-fonts.hack
    spotify
  ];

  home.file = {
  };
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
     GTK_THEME = "Catppuccin-Mocha";
     LIBRARY_PATH = "$HOME/.nix-profile/lib";
     LD_LIBRARY_PATH = "$HOME/.nix-profile/lib";
     CPATH = "$HOME/.nix-profile/include";
     EDITOR = lib.mkForce "vscode";
     TERMINAL = "alacritty";
  };

  programs.home-manager.enable = true;


}
