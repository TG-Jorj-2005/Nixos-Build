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
       naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, home-manager, pyprland, naersk, ... }@inputs:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      naerskLib = pkgs.callPackage naersk {};
  in
   {
    nixosConfigurations={
    Nixos-JRJ-BRW = lib.nixosSystem {
      inherit system;
      modules = [
          
         ./configuration.nix
      ];
    };
  };
  packages.system.default = naerskLib.buildPackage {
    src =./.;
    buildInputs = [pkgs.glib];
    nativeBuildInputs = [pkgs.pkg-config];
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
