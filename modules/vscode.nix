{config, pkgs, lib, ...}:
{

 programs.vscode = {
   enable = true;
   
   package = [ pkgs.vscode pkgs.vscodium ];
   
   defaultEditor = true;
   
   haskell.enable = true;
   python.enable = true;
   rust.enable = true;
   gcc.enable = true ; 

   extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-vscode.cpptools
      haskell.haskell
      rust-lang.rust-analyzer
      eamodio.gitlens
    ];  
    
      settings = {
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "files.autoSave" = "afterDelay";
      "workbench.colorTheme" = "Forest Night - Ethereal";
    };

    };


    
  }
