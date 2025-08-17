{ config, pkgs, ... }:
let
  gruVboxTheme = pkgs.writeText "Gruvbox-Dark.json" ''
    {
      "background": "#282828",
      "foreground": "#ebdbb2",
      "cursor-color": "#fe8019",
      "palette": [
        "#282828", "#cc241d", "#98971a", "#d79921",
        "#458588", "#b16286", "#689d6a", "#a89984",
        "#928374", "#fb4934", "#b8bb26", "#fabd2f",
        "#83a598", "#d3869b", "#8ec07c", "#ebdbb2"
      ],
      "selection-background": "#3c3836",
      "selection-foreground": "#ebdbb2"
    }
  '';
in
{
  programs.ghostty = {
    enable = true;
     themes = {
      "Gruvbox-Dark" = builtins.fromJSON (builtins.readFile gruVboxTheme);
    };
    settings = {
      font-size = 12;
      background-opacity = 1.0; # fără transparență -> start mai rapid
    };

    # Dezactivate pentru test -> prompt mai rapid
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}

