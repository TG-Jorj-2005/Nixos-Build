{ inputs, config, pkgs, ... }:

{
  imports = [ ./modules/sh.nix
              ./modules/hyprland.nix
	      ./modules/git.nix
	      ./modules/starhip.nix
	      ./modules/waybar.nix
	      ./modules/rofi.nix
	      ./modules/alacritty.nix
	      ./modules/rust.nix   
		       ];


 home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

   theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      name = "Sans";
      size = 12;
    };
  };

  qt={
  enable = true;
  platformTheme.name = "gtk";
  style = {
    name = "gtk2"; 
   };
  };

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jorj";
  home.homeDirectory = "/home/jorj";

  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    brave
    curl
    wget
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code  
    nerd-fonts.hack
    spotify
    vscode
  ];

  home.file = {
  };
  fonts.fontconfig.enable = true;
  home.sessionVariables = {
     EDITOR = "nvim";
     GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
  };

  programs.home-manager.enable = true;

rograms.neovim = {
    enable = true;
    defaultEditor = true;
    
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

      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      -- Soluție pentru permisiuni: scriere forțată și comandă sudo
      vim.o.writeany = true

      -- Comandă personalizată pentru scriere cu sudo
      vim.api.nvim_create_user_command('SudoWrite', function()
        local file = vim.fn.expand('%')
        if file == '' then
          vim.notify('No file name', vim.log.levels.ERROR)
          return
        end
        vim.cmd('w !sudo tee > /dev/null %')
        vim.cmd('e!')
        vim.notify('File written with sudo: ' .. file, vim.log.levels.INFO)
      end, { desc = 'Write file with sudo' })

      -- Mapping pentru scriere forțată și sudo
      vim.keymap.set('n', '<leader>w', ':write!<CR>', { desc = 'Force write file' })
      vim.keymap.set('n', '<leader>W', ':SudoWrite<CR>', { desc = 'Sudo write file' })

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.extras.coding.copilot" },
          { import = "lazyvim.plugins.extras.lang.typescript" },
          { import = "lazyvim.plugins.extras.lang.json" },
          { import = "lazyvim.plugins.extras.lang.python" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        checker = { enabled = true },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip", "matchit", "matchparen", "netrwPlugin",
              "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
          },
        },
      })
      require("lazyvim").setup()
    '';
  };
}
