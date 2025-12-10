{ pkgs ? import {} }:

pkgs.stdenv.mkDerivation {
 name = "axiomhive-sovereign-3.1.0";
 src = ./.;

 nativeBuildInputs = [ pkgs.poetry pkgs.rustc pkgs.cargo ];

 buildPhase = ''
 poetry install --no-dev
 cargo build --release
 '';

 installPhase = ''
 mkdir -p $out/bin
 cp target/release/axiomhive-kernel $out/bin/
 '';
}
