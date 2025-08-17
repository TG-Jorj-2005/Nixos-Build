{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      background-opacity = 1.0; # fără transparență -> start mai rapid
      theme = "catppuccin-mocha"; # aplică tema direct
    };

    # Dezactivate pentru test -> prompt mai rapid
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}

