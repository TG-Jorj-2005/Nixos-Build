{config, lib, pkgs,...}:
{
programs.neovim = {
    enable = true;
    vimAlias = true;
    packages = pkgs.neovim-nightly
    plugins = with pkgs.vimPlugins;[vimPlugins.LazyVim];
};


}
