set -e
unset PATH
for p in $baseInputs $buildInputs; do
    export PATH=$p/bin${PATH:+:}$PATH
done

echo "echoing... $echoMsg"

mkdir $out

cd $src

cargo build $cargoBuildOptions --target-dir $out