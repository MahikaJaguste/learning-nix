set -e

unset PATH
for p in $baseInputs $nativeBuildInputs; do
    export PATH=$p/bin${PATH:+:}$PATH
done

function configurePhase() {
    eval "$configurePhase"
}

function buildPhase() {
    eval "$buildPhase"
}

function installPhase() {
    eval "$installPhase"
}

function genericBuild() {
    configurePhase
    buildPhase
    installPhase
}

genericBuild