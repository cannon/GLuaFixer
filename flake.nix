{
  description = "glualint - Linter and pretty printer for Garry's Mod's variant of Lua.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      haskellPackages = pkgs.haskellPackages;
    in {
      packages.glualint = haskellPackages.callPackage ./default.nix {};
      defaultPackage = self.packages.${system}.glualint;

      devShell = pkgs.mkShell {
        buildInputs = with haskellPackages; [
          cabal-install
          (ghcWithPackages (self: with self; [
            aeson array base bytestring containers directory filemanip filepath
            ListLike MissingH mtl optparse-applicative parsec pretty signal
            uu-parsinglib uuagc uuagc-cabal deepseq
          ]))
        ];
      };
    }
  );
}
