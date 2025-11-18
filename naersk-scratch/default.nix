
{ 
  cargo
, lib
, pkgs
}@defaultBuildAttrs:
let 
    mkConfig = arg: import ./config.nix arg;
    mkDerivation = import ./mkDerivation.nix pkgs;
    
    buildPackage = arg: 
        let
            config = mkConfig arg;
            build = import ./build.nix ({
                inherit mkDerivation;
            } // config.buildConfig // defaultBuildAttrs);
        in
            build;
in
{
    inherit buildPackage;
}