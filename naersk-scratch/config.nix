arg:
let
  mkAttrs = attrs0:
  {
    name = attrs0.name or null;
    version = attrs0.version or null;

    src = attrs0.src or null;

    cargoBuild = ''cargo build $cargo_build_options >> $cargo_build_output_json'';
    cargoBuildOptions = [ ''-j "$NIX_BUILD_CORES"'' ];

    copyBins = attrs0.copyBins or true;
    copyLibs = attrs0.copyLibs or true;
    copyTarget = attrs0.copyTarget or false;
  };

  attrs = mkAttrs arg;

  buildConfig = {
    cargoCommand = attrs.cargoBuild;
    pname =
      if ! isNull attrs.name
      then attrs.name
      else "rust-package";

    version =
      if ! isNull attrs.version
      then attrs.version
      else "unknown";

    inherit (attrs)
      src
      cargoBuildOptions
      copyBins
      copyLibs
      copyTarget;
  };
in
{ 
  inherit buildConfig;
}
