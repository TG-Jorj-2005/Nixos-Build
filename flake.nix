{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
     home-manager = {
       url = "github:nix-community/home-manager/master";
       inputs.nixpkgs.follows = "nixpkgs";
       };
       pyprland.url = "github:hyprland-community/pyprland";
       nvf.url = "github:;notashelf/nvf";

 };

  outputs = { self, nixpkgs, home-manager, pyprland, nvf, ... }@inputs:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
  in
   {
    packages.system.default = 
    (nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [./assets/nvf-configuration.nix];
    }).neovim;

    nixosConfigurations={
    Nixos-JRJ-BRW = lib.nixosSystem {
      inherit system;
      modules = [
          nvf.nixosModules.default
         ./configuration.nix
      ];
    };
  };
homeConfigurations = {
   jorj = home-manager.lib.homeManagerConfiguration {
     inherit pkgs;
     modules = [./home.nix];
     extraSpecialArgs = {inherit inputs;};

     };
  };
};

}
