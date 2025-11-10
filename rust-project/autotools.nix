pkgs: attrs:
let 
    defaultAttrs = {
        builder = "${pkgs.bash}/bin/bash"; 
        args = [ ./builder.sh ]; 
        baseInputs = with pkgs; [
            cargo
            coreutils
            clang
        ];
        buildInputs = [];
        system = builtins.currentSystem; 
        echoMsg = "default echo message";
    };
in
derivation (defaultAttrs // attrs)