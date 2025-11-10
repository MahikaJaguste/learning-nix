let
    nixpkgs = import <nixpkgs> { };
    allPkgs = nixpkgs // pkgs;
    callPackage =
        path: overrides:
        let
            f = import path;
        in
            f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
    pkgs = with nixpkgs; {
        mkDerivation = import ./autotools.nix nixpkgs;
        adder = callPackage ./adder.nix { };
        add_one = callPackage ./add_one.nix { };
    };
in
pkgs
