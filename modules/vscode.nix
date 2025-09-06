{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vscode           # sau vscodium
    nixpkgs-fmt     # formatter pentru Nix
    nixd             # Language Server Protocol
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;  # sau pkgs.vscodium
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide         # Nix IDE: syntax, snippets, linting
      jeff-hykin.better-nix-syntax  # highlight mai bun
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";  # sau "nil" dacă folosești nil
      "nix.formatterPath" = "nixpkgs-fmt";
      "nix.serverSettings" = {
        nixd = {
          formatting.command = [ "nixpkgs-fmt" ];
        };
      };
    };
  };
}
