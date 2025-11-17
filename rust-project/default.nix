
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
        naersk_scratch = callPackage ../naersk-scratch/default.nix {};
        rust_project = naersk_scratch.buildPackage {
            name = "my-rust-project";
            version = "0.1";
            src = ./.;
        };
    };
in
pkgs