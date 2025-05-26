{ nixpkgs ? import <nixpkgs> {  } }:
let
  # You can get a newer ref by looking under "nixpkgs-unstable" in https://status.nixos.org/
  nixpkgsRev = "ea5234e7073d5f44728c499192544a84244bf35a";
  nixpkgsSha = "sha256:1iqfglh1fdgqxm7n4763k1cipna68sa0cb3azm2gdzhr374avcvk";
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${nixpkgsRev}.tar.gz";
    sha256 = nixpkgsSha;
  }) {} ;


in
  pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs =  [
			pkgs.tree
			pkgs.websocat
			pkgs.nodePackages.live-server
			
			
			pkgs.purescript
			pkgs.nodejs_18
			pkgs.spago
			pkgs.esbuild
			pkgs.nodePackages_latest.pscid
			pkgs.nodePackages_latest.bower ## e.g. bower install purescript-websocket-simple
			pkgs.typescript
    ];

     shellHook = ''
         echo "Entering my Nix shell environment..."
     '';


}
