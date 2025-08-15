{ config, pkgs, ... }:

{
  imports = [ ./modules/sh.nix
              ./modules/hyprland.nix         
		       ];
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
  ];


  home.file = {
  };

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
