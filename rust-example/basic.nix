let
  # Import nixpkgs
  nixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  }) {};

  # Import naersk
  # Import naersk with fetchurl from nixpkgs
  naersk = import (fetchTarball {
    url = "https://github.com/nix-community/naersk/archive/master.tar.gz";
  }) { inherit (nixpkgs) 
    fetchurl 
    cargo 
    rustc 
    clippy 
    jq 
    lib
    lndir
    remarshal
    formats
    rsync
    runCommandLocal
    stdenv
    writeText
    zstd; 
    pkgs = nixpkgs;
  };
in
{
  # Build the Rust package
  defaultPackage = naersk.buildPackage {
    src = ./.; # Path to your Rust project
  };

  # Development shell
  devShell = nixpkgs.mkShell {
    buildInputs = with nixpkgs; [
      cargo
      rustc
      rustfmt
      pre-commit
      rustPackages.clippy
    ];
    RUST_SRC_PATH = nixpkgs.rustPlatform.rustLibSrc;
  };
}