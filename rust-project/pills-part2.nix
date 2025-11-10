let
  pkgs = import <nixpkgs> { };
in
derivation { 
    name = "simple"; 
    builder = "${pkgs.bash}/bin/bash"; 
    args = [ ./builder.sh ]; 
    buildInputs = with pkgs; [
        cargo
        coreutils
        clang
    ];
    cargoBuildOptions = ["-p adder"];
    src = ./.;
    system = builtins.currentSystem; 
}