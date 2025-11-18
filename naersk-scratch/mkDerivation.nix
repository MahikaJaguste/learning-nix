pkgs: attrs:
let 
    defaultAttrs = {
        builder = "${pkgs.bash}/bin/bash"; 
        args = [ ./builder.sh ];
        system = builtins.currentSystem;
        baseInputs = with pkgs; [
            coreutils
            findutils
            clang
            gcc
        ];
    };
in
derivation (defaultAttrs // attrs)