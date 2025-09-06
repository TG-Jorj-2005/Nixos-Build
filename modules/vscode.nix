{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode
    gcc gdb cmake make pkg-config
    raylib SDL2 boost opencv
    nixpkgs-fmt nixd
  ];

 programs.vscode = {
  enable = true;
  package = pkgs.vscode;
  profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vscode.cmake-tools
      twxs.cmake
      jnoortheen.nix-ide
      jeff-hykin.better-nix-syntax
    ];
    userSettings = {
      "editor.formatOnSave" = true;
      "files.autoSave" = "afterDelay";
      "C_Cpp.default.cppStandard" = "c++20";
      "C_Cpp.default.cStandard" = "c17";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixpkgs-fmt";
    };
  };
};
}

