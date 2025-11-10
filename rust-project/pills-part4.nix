let 
    pkgs = import <nixpkgs> {};
    mkDerivation = import ./autotools.nix pkgs;
in {
    adder = import ./adder.nix { inherit mkDerivation; };
    add_one = import ./add_one.nix { inherit mkDerivation; };
}