{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Configurația minimă pentru LazyVim
    extraLuaConfig = ''
      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- Setări de bază
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      -- LazyVim setup
      require("lazy").setup({
        spec = {
          -- Import LazyVim
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- Extras opționale
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        checker = { enabled = true },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "matchit",
              "matchparen", 
              "netrwPlugin",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';
  };

  # Doar dependențele esențiale
  home.packages = with pkgs; [
    # Căutare
    ripgrep
    fd
    
    # Git
    lazygit
    git
    
    # Build tools
    nodejs
    python3
    gcc
    
    # LSP basics
    lua-language-server
    nil
  ];
}
