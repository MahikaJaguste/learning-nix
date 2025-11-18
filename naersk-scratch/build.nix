{ src
, cargoBuildOptions
, copyTarget
, copyBins
, copyLibs
, pname
, version
, cargo
, mkDerivation
, lib
, pkgs
}:
let
    drvAttrs = {
        name = "${pname}-${version}";
        inherit src copyBins copyLibs copyTarget;

        nativeBuildInputs = [ cargo ];

        configurePhase = ''
            targetDir="$PWD/target"
            mkdir -p "$targetDir"
            cd "$src"
        '';

        buildPhase = ''
            cargoCommand="cargo build $cargoBuildOptions --target-dir $targetDir"

            cargo_ec=0
            eval  "$cargoCommand" || cargo_ec="$?"

            if [ "$cargo_ec" -ne "0" ]; then
                echo "cargo returned with exit code $cargo_ec, exiting"
                exit "$cargo_ec"
            fi
        '';

        installPhase = ''
            ${lib.optionalString copyBins ''
                mkdir -p $out/bin
                echo "copying executables"
                find $targetDir/debug -maxdepth 1 -type f -executable \
                    -not -name '*.so' -a -not -name '*.dylib' -a -not -name '*.a' \
                    -exec cp {} $out/bin \;
            ''}

            ${lib.optionalString copyLibs ''
                mkdir -p $out/lib
                echo "copying lib files"
                find $targetDir/debug -maxdepth 1 -type f \
                    \( -name '*.so' -or -name '*.dylib' -or -name '*.a' \) \
                    -exec cp {} $out/lib \;
            ''}

            ${lib.optionalString copyTarget ''
                echo "copying target"
                mkdir -p $out
                cp -r $targetDir $out
            ''}
        '';
    };

    drv = mkDerivation drvAttrs;
in
    drv