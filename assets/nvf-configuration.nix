{pkgs,lib, ...}:
{ 
 vim = {
 theme = {
  enable = true;
  name = "gruvbox";
  style = "dark";
   };
 };
 languages ={
  enableLSP = true;
  enableTreesitter = true;
  };
  nix.enable = true;
  ts.enable = true;
  rust.enable = true;

 statusline.lualine.enable = true;
 telescope.enable = true;
 vim.languages.nix.enable = true;
}
