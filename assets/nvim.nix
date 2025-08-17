{config, lib, pkgs,...}:
{
programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins;[
    LazyVim  ];
    extraConfig = ''
      " Clonăm LazyVim într-un folder local
      if empty(glob(expand("~/.config/nvim/lazy/lazy.nvim")))
        silent !git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.config/nvim/lazy/lazy.nvim
      endif

      " Setăm runtimepath
      set runtimepath+=~/.config/nvim/lazy/lazy.nvim

      " LazyVim init.lua
      lua << EOF
      require("lazy").setup("LazyVim/LazyVim", {})
      EOF
    '';

    };


}
