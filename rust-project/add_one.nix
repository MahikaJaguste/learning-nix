{mkDerivation, echoMsg ? ""}:
mkDerivation {
    name = "add_one"; 
    src = ./.;
    cargoBuildOptions = ["-p add_one"];
    echoMsg = echoMsg;
}