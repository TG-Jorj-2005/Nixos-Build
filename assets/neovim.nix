{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Configurația LazyVim
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

      -- LazyVim setup
      require("lazy").setup({
        spec = {
          -- Import LazyVim și plugin-urile sale
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- Import orice extras dorite
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.ui.mini-animate" },
          -- Import plugin-urile personale din lua/plugins
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false, -- folosește întotdeauna ultima versiune
        },
        checker = { enabled = true }, -- verifică automat pentru actualizări
        performance = {
          rtp = {
            -- dezactivează plugin-uri built-in pe care nu le folosești
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

      -- Setări LazyVim
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"
      
      -- Opțiuni de bază
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = "a"
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = false
      vim.opt.breakindent = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.completeopt = "menuone,noselect"
      vim.opt.undofile = true
    '';

    # Plugin-uri esențiale pentru LazyVim
    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      lazy-nvim
      
      # LazyVim core
      LazyVim
      
      # UI
      tokyonight-nvim
      lualine-nvim
      nvim-web-devicons
      dressing-nvim
      
      # Editor
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      
      # LSP
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      
      # Git
      gitsigns-nvim
      
      # File explorer
      neo-tree-nvim
      
      # Utilities
      which-key-nvim
      comment-nvim
      indent-blankline-nvim
      
      # Dependencies
      plenary-nvim
      nui-nvim
    ];
  };

  # Dependențe externe necesare
  home.packages = with pkgs; [
    # Căutare și navigare
    ripgrep
    fd
    fzf
    
    # Git
    lazygit
    
    # LSP servers și tools
    nodejs
    python3
    
    # Compilatori
    gcc
    
    # Formatters și linters
    stylua
    nixpkgs-fmt
    
    # Language servers comune
    lua-language-server
    nil # Nix LSP
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier
  ];

  # Configurații suplimentare pentru shell
  programs.zsh.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  programs.bash.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };
}
