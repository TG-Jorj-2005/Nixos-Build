{ config, pkgs, ... }:

let
  lazy_path = "${pkgs.vimPlugins.lazy-nvim}/share/nvim/site/pack/packer/start/lazy.nvim";
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;

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

