{
  description = "Corne ZMK firmware development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          west
          pyelftools
          pyyaml
          pyudev
          packaging
          pyserial
          python-can
          canopen
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          name = "corne-zmk-dev";

          buildInputs = with pkgs; [
            pythonEnv
            gcc-arm-embedded
            cmake
            ninja
            dfu-util
            git
            wget
            unzip
            dtc
            openocd
            just
          ];

          shellHook = ''
            echo "Corne ZMK Development Shell"
            echo "======================================"
            echo "West version: $(west --version)"
            echo "ARM GCC version: $(arm-none-eabi-gcc --version | head -1)"
            echo ""
            echo "Available commands:"
            echo "  just build       - Build all halves"
            echo "  just build-left  - Build left half"
            echo "  just build-right - Build right half"
            echo "  just flash-left  - Flash left half"
            echo "  just flash-right - Flash right half"
          '';
        };
      });
}
