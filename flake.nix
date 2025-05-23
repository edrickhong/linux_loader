{
  description = "Linux Loader";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        fakeLibPath = pkgs.runCommand "fake-lib-dir" {} ''
          mkdir -p $out/lib
          cp ${pkgs.glibc}/lib/libc.so.6 $out/lib/
          cp ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $out/lib/
          cp ${pkgs.zlib}/lib/libz.so.1 $out/lib/
          cp ${pkgs.libffi}/lib/libffi.so.8 $out/lib/
        '';
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cmake
            clang
            gdb
            cgdb

            dbus
            pkg-config
            alsa-lib
            xorg.libX11
            wayland
            libffi
          ];

          shellHook = ''
            export LD_LIBRARY_PATH=${fakeLibPath}/lib
            export LD_BIND_NOW=1
            export LD_PRELOAD=
            echo '[ld.so emu] LD_LIBRARY_PATH=$LD_LIBRARY_PATH'
          '';
        };
      });
}

