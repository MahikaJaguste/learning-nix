{mkDerivation, echoMsg ? ""}:
mkDerivation {
    name = "adder"; 
    src = ./.;
    cargoBuildOptions = ["-p adder"];
    echoMsg = echoMsg;
}