{ inputs, config, pkgs, ... }:

{
  imports = [ ./modules/sh.nix
              ./modules/hyprland.nix
	      ./modules/git.nix
	      ./modules/fuzzel.nix
	      ./modules/starhip.nix
	      ./modules/waybar.nix
	      inputs.catppuccin.homeManagerModules.catppuccin
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
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papiruis-Dark";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  qt={
  enable = true;
  platformTheme = "gtk";
  style = {
    name = "gtk2"; 
   };
  };

  catppuccin.waybar.enable = true;
  
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
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code  
    nerd-fonts.hack
    spotify
    vscode
    vimPlugins.LazyVim
  ];

  home.file = {
  };
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
     EDITOR = "nvim";
     GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
  };

  programs.home-manager.enable = true;
}
