{config, pkgs , ...}:
{

programs.rofi = {
  enable = true;
  font = "Droid Sans Mono 14";
  location = "center";
  package = pkgs.rofi.override { plugins = [ pkgs.rofi-emoji ]; }

  };




}

