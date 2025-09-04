{ config, pkgs, lib, ... }:

{
  # VSCode și setările sale
  programs.vscode = {
    enable = true;
    package =  pkgs.vscode;


    # Extensii utile
    extensions = with pkgs.vscode-extensions; [
      # Python
      ms-python.python
      ms-toolsai.jupyter

      # Rust
      rust-lang.rust-analyzer

      # Haskell
      haskell.haskell

      # C/C++
      ms-vscode.cpptools

      # Git / Version control
      eamodio.gitlens

      # Productivity
      esbenp.prettier-vscode
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers
    ];

};
  # Pachete utile în PATH
  home.packages = [
    pkgs.python310Full
    pkgs.nodejs
    pkgs.zsh
    pkgs.cmake
    pkgs.gcc
    pkgs.gnumake
    pkgs.raylib
    pkgs.libx11
  ];
   home.sessionVariables = {
    LIBRARY_PATH = "${pkgs.xorg.libX11}/lib:${pkgs.libGL}/lib:$LIBRARY_PATH";
    LD_LIBRARY_PATH = "${pkgs.xorg.libX11}/lib:${pkgs.libGL}/lib:$LD_LIBRARY_PATH";
    CPATH = "${pkgs.xorg.libX11}/include:${pkgs.libGL}/include:$CPATH";
  };

}

