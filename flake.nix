{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    roc.url = "github:roc-lang/roc?rev=03eadc2e0f9cecc83ab2c24cb29decec59d58d48";
  };

  nixConfig = {
    extra-trusted-public-keys = "roc-lang.cachix.org-1:6lZeqLP9SadjmUbskJAvcdGR2T5ViR57pDVkxJQb8R4=";
    extra-trusted-substituters = "https://roc-lang.cachix.org";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    roc,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
      perSystem = {
        inputs',
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          name = "roc-math";
          packages = [
            roc.packages.${system}.cli
            pkgs.just
            pkgs.pre-commit
            pkgs.alejandra
          ];
          enterShell = "pre-commit install --overwrite";
        };
      };
    };
}
