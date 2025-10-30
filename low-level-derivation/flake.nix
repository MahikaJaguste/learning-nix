{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs }:
	let
		pkgs = nixpkgs.legacyPackages.${system};
		system = "aarch64-darwin";
	in {
		packages.${system} = {
			low_level_derivation = derivation {
				name = "low-level-derivation";
				system = system;
				builder = "${pkgs.bash}/bin/bash";
				args = [
					"-c"
					''
					export PATH="$PATH:${pkgs.coreutils}/bin"
					echo '#!${pkgs.bash}/bin/bash' > $out
					echo 'echo "Hello, World!"' >> $out
					chmod +x $out
					''
				];
			};
			abstracted_derivation = pkgs.stdenv.mkDerivation {
				name = "abstracted-derivation";
				
				buildCommand = ''
					echo '#!/bin/bash' > $out
					echo 'echo "Hello, World!"' >> $out
					chmod +x $out
				'';
			};
		};
	};
}