
let
    nixpkgs = import <nixpkgs> { };
    allPkgs = nixpkgs // pkgs;
    makeOverridable =
        f: origArgs:
        let
            origRes = f origArgs;
        in
            origRes // { override = newArgs: makeOverridable f (origArgs // newArgs); };
    callPackage =
        path: overrides:
        let
            f = import path;
        in
            makeOverridable f ((builtins.intersectAttrs (builtins.functionArgs f) allPkgs) // overrides);
    pkgs = with nixpkgs; rec {
        mkDerivation = import ./autotools.nix nixpkgs;
        adder = callPackage ./adder.nix {};
        adder_abc = adder.override { echoMsg = "abc"; };
        adder_def = adder_abc.override { echoMsg = "def"; };
        add_one = callPackage ./add_one.nix {};
    };
in
pkgs


