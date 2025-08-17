{ config, pkgs, ... }:

let
  catppuccinColors = {
    background    = "#1e1e2e";
    foreground    = "#cdd6f4";
    cursor        = "#f5e0dc";
    black         = "#45475a";
    red           = "#f38ba8";
    green         = "#a6e3a1";
    yellow        = "#f9e2af";
    blue          = "#89b4fa";
    magenta       = "#f5c2e7";
    cyan          = "#94e2d5";
    white         = "#bac2de";
    brightBlack   = "#585b70";
    brightRed     = "#f38ba8";
    brightGreen   = "#a6e3a1";
    brightYellow  = "#f9e2af";
    brightBlue    = "#89b4fa";
    brightMagenta = "#f5c2e7";
    brightCyan    = "#94e2d5";
    brightWhite   = "#a6adc8";
  };
in
{
  programs.alacritty.enable = true;

  programs.alacritty.font = {
    normal = {
      family = "FiraCode Nerd Font";
      style  = "Regular";
    };
    size = 12;
  };

  programs.alacritty.colors = {
    primary = {
      background = catppuccinColors.background;
      foreground = catppuccinColors.foreground;
    };
    cursor = {
      text   = catppuccinColors.background;
      cursor = catppuccinColors.cursor;
    };
    normal = {
      black   = catppuccinColors.black;
      red     = catppuccinColors.red;
      green   = catppuccinColors.green;
      yellow  = catppuccinColors.yellow;
      blue    = catppuccinColors.blue;
      magenta = catppuccinColors.magenta;
      cyan    = catppuccinColors.cyan;
      white   = catppuccinColors.white;
    };
    bright = {
      black   = catppuccinColors.brightBlack;
      red     = catppuccinColors.brightRed;
      green   = catppuccinColors.brightGreen;
      yellow  = catppuccinColors.brightYellow;
      blue    = catppuccinColors.brightBlue;
      magenta = catppuccinColors.brightMagenta;
      cyan    = catppuccinColors.brightCyan;
      white   = catppuccinColors.brightWhite;
    };
  };

  programs.alacritty.drawBoldTextWithBrightColors = true;
  programs.alacritty.opacity                  = 0.96;
  programs.alacritty.hideMouseWhenTyping     = true;
}

