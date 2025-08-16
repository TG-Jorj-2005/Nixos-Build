{config, lib, pkgs, ...}:
{
{ pkgs, ... }:

{
  systemd.user.services.swww = {
    Unit = {
      Description = "swww wallpaper daemon";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.services.set-wallpaper = {
    Unit = {
      Description = "Set wallpaper with swww";
      After = [ "swww.service" ];
    };

    Service = {
      ExecStart = "${pkgs.swww}/bin/swww img ~/Downloads/eye.gif --transition-type any";
      Type = "oneshot";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}




}
