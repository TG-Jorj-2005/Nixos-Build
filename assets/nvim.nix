{config, lib, pkgs,...}:
let
  lazy_path = "${pkgs.vimPlugins.lazy-nvim}/share/nvim/site/pack/packer/start/lazy.nvim";
in
{
programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins;[
    LazyVim  ];
    extraConfig = ''
   
      set runtimepath+=${lazy_path}

     lua <<EOF
      local lazy = require("lazy")
      lazy.setup({
        spec = {
          { import = "LazyVim.plugins" },
        },
      })
      EOF
      '';

    };


}
