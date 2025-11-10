export PATH="$cargo/bin:$coreutils/bin:$gcc/bin"
mkdir $out
cd $src
cargo build $cargoBuildOptions --target-dir $out
