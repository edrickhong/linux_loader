{
  description = "Linux Loader";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            clang  # or clang
	    gdb
            cgdb
	    
	    dbus
	    pkg-config
	    alsa-lib
	    xorg.libX11
	    wayland
	    libffi
          ];
        };
      });
}

