{config, lib, pkgs,...}:
let
 lazy_path = "/home/jorj/.config/nvim/";
in
{
programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins;[
    LazyVim  ];
    extraConfig = ''
      git clone https://github.com/LazyVim/LazyVim.git ${lazy_path}


   '';

      };


}
