{ config, pkgs, ... }:

let
  lazy_path = "${pkgs.vimPlugins.lazy-nvim}/share/nvim/site/pack/packer/start/lazy.nvim";
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = pkgs.neovim;

    extraConfig = ''
      " Adăugăm lazy.nvim în runtimepath
      set runtimepath+=${lazy_path}

      " Configurăm LazyVim prin Lua
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

