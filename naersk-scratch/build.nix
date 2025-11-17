{ src
, cargoCommand
, cargoBuildOptions
, copyTarget
, copyBins
, copyLibs
, pname
, version
, cargo
, stdenv
, lib
, pkgs
}:
let
    drvAttrs = {
        name = "${pname}-${version}";
        inherit src;

        nativeBuildInputs = [ cargo ];
        cargo_build_options = cargoBuildOptions;

        configurePhase = ''
            runHook preConfigure


            logRun() {
                >&2 echo "$@"
                eval "$@"
            }


            cargo_build_output_json=$(mktemp)

            echo "cargo_build_options: $cargo_build_options"
            echo "cargo_build_output_json (created): $cargo_build_output_json"

            mkdir -p target

            runHook postConfigure
        '';

        buildPhase = ''
            runHook preBuild

            cargo_ec=0
            logRun ${cargoCommand} || cargo_ec="$?"

            if [ "$cargo_ec" -ne "0" ]; then
                echo "cargo returned with exit code $cargo_ec, exiting"
                exit "$cargo_ec"
            fi

            runHook postBuild
        '';

        installPhase =
        ''
            runHook preInstall

            ${lib.optionalString copyBins ''
            mkdir -p $out/bin
            echo "copying executables"
            find target/debug -maxdepth 1 -type f -executable \
                -not -name '*.so' -a -not -name '*.dylib' -a -not -name '*.a' \
                -exec cp {} $out/bin \;
            ''}

            ${lib.optionalString copyLibs ''
            mkdir -p $out/lib
            echo "copying lib files"
            find target/debug -maxdepth 1 -type f \
                \( -name '*.so' -or -name '*.dylib' -or -name '*.a' \) \
                -exec cp {} $out/lib \;
            ''}

            ${lib.optionalString copyTarget ''
            echo "copying target"
            mkdir -p $out
            cp -r target $out
            ''}

            runHook postInstall
        '';
    };

    drv = stdenv.mkDerivation drvAttrs;
in
    drv