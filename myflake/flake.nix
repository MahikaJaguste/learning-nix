{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in 
  {
    packages.${system} = rec {
      hello = pkgs.hello;
      default = hello;
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [pkgs.neovim];
    };
  };
}