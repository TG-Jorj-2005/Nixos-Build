{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
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

      -- Setări de bază pentru LazyVim
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      -- Încarcă LazyVim
      require("lazy").setup({
        spec = {
          -- Importă totul de la LazyVim
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          
          -- Extras-uri recomandate
          { import = "lazyvim.plugins.extras.coding.copilot" },
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.lang.python" },
          { import = "lazyvim.plugins.extras.ui.mini-animate" },
          { import = "lazyvim.plugins.extras.util.project" },
          
          -- Poți adăuga plugin-uri personalizate aici mai târziu
          -- { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        checker = { 
          enabled = true,
          frequency = 3600, -- verifică o dată pe oră
        },
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

      -- Încarcă configurația LazyVim
      require("lazyvim").setup()
    '';
  };

  # Toate dependențele necesare pentru LazyVim
  home.packages = with pkgs; [
    # Utilitare pentru căutare
    ripgrep
    fd
    fzf
    
    # Sistem de fișiere
    unzip
    zip
    
    # Git
    lazygit
    git
    gh
    
    # Build tools și compilatoare
    gnumake
    gcc
    pkg-config
    cmake
    ninja
    
    # Limbaje de programare
    nodejs
    python3
    rustc
    cargo
    
    
    # LSP servers esențiale
    lua-language-server
    nil                   # Nix LSP
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON
    pyright
    rust-analyzer
    nodePackages.bash-language-server
    
    # Formatters
    nodePackages.prettier
    black                 # Python formatter
    shfmt                 # Shell formatter
    nixpkgs-fmt           # Nix formatter
    
    
    # Alte utilitare
    tree-sitter           # Pentru syntax highlighting
    curl
    wget
  ];
}
