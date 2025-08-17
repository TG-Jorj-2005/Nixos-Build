{config, lib, pkgs,...}:
{
programs.neovim = {
    enable = true;
    vimAlias = true;
    package = pkgs.neovim-nightly;
    plugins = with pkgs.vimPlugins;[vimPlugins.LazyVim];
};


}
