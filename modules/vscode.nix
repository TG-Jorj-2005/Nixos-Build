{ config, pkgs, lib, ... }:

{
  # VSCode și setările sale
  programs.vscode = {
    enable = true;
    package = [ pkgs.vscode ];


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
    pkgs.gcc
    pkgs.gnumake
    pkgs.python310Full
    pkgs.rustc
    pkgs.cargo
    pkgs.nodejs
    pkgs.git
    pkgs.zsh
    pkgs.cmake
  ];

}

