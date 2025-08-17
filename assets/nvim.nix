{config, lib, pkgs,...}:
{
programs.neovim = {
    enable = true;
    plugins = vimPlugins.LazyVim;
};


}
