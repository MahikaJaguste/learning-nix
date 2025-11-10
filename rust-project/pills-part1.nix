let
  pkgs = import <nixpkgs> { };
in
derivation { 
    name = "simple"; 
    builder = "${pkgs.bash}/bin/bash"; 
    args = [ ./simple_builder.sh ]; 
    inherit (pkgs) cargo coreutils;
    src = ./.; 
    cargoBuildOptions = ["-p adder"];
    gcc = pkgs.clang;
    system = builtins.currentSystem; 
}
