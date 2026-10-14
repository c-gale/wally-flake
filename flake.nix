{
  description = "Flake for Wally CLI binary v0.3.2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.wally = pkgs.stdenv.mkDerivation {
        pname = "wally";
        version = "0.3.2";

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.unzip
        ];

        buildInputs = with pkgs; [
          zlib
          openssl
          libgcc
        ];

        src = pkgs.fetchzip {
          url = "https://github.com/UpliftGames/wally/releases/download/v0.3.2/wally-v0.3.2-linux.zip";
          sha256 = "sha256-EdCTWWxwJeTDuICEmtkG20vxLJUI1IrrKcVivFKkLVM=";
          stripRoot = false;
        };

        installPhase = ''
          mkdir -p $out/bin
          cp $src/wally $out/bin/wally
          chmod +x $out/bin/wally
        '';
      };

      defaultPackage.${system} = self.packages.${system}.wally;

      devShells.${system}.default = pkgs.mkShell {
        packages = [ self.packages.${system}.wally ];
      };
    };
}
