{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    # Tema Catppuccin minimală pentru start rapid
    themes = {
      catppuccin-mocha = {
        background = "1e1e2e";
        cursor-color = "f5e0dc";
        foreground = "cdd6f4";
        # Folosim palette minimală ca să nu încetinească
        palette = [
          "0=#45475a"
          "1=#f38ba8"
          "2=#a6e3a1"
          "3=#f9e2af"
          "4=#89b4fa"
          "5=#f5c2e7"
          "6=#94e2d5"
          "7=#bac2de"
        ];
        selection-background = "353749";
        selection-foreground = "cdd6f4";
      };
    };

    # Setări rapide
    settings = {
      font-size = 12;
      background-opacity = 0.97;  # fără transparență la start
    };

    # Dezactivăm integrarea shell-ului pentru a accelera pornirea
    enableBashIntegration = false;
    enableZshIntegration = false;

  };
}

