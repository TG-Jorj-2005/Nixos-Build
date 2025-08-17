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
      crate2nix.url = "github:kolloch/crate2nix";

 };

  outputs = { self, nixpkgs, home-manager, pyprland, crate2nix, ... }@inputs:
  let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      rustPkgs = import ./Cargo.nix {inherit pkgs;};
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
   packages.${system}.default = rustPkgs.rootCrate.build;

      # Shell de dezvoltare
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.rustc
          pkgs.cargo
          pkgs.rust-analyzer
        ];
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
