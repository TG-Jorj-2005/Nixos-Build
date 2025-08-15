{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

     home-manager = {
       url = "github:nix-community/home-manager/master";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
  homeConfigurations = {
   jorj = home-manager.lib.homeManagerConfiguration {
     inherit pkgs;
     modules = [./home.nix];

     };
  };
};

}
