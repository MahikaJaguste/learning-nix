
{ 
  cargo
, lib
, stdenv
, pkgs
}@defaultBuildAttrs:
let 
    mkConfig = arg: import ./config.nix arg;
    
    buildPackage = arg: 
        let
            config = mkConfig arg;
            build = import ./build.nix (config.buildConfig // defaultBuildAttrs);
        in
            build;
in
{
    inherit buildPackage;
}