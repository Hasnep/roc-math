{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    roc.url = "github:roc-lang/roc?rev=44d76d78a13e6b6b4adea075a93b3b46989704f2";
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
        ...
      }: {
        devShells.default = pkgs.mkShell {
          name = "roc-math";
          packages = [
            inputs'.roc.packages.cli
            pkgs.just
            pkgs.pre-commit
            pkgs.alejandra
              pkgs.fd
          ];
          enterShell = "pre-commit install --overwrite";
        };
        formatter = pkgs.alejandra;
      };
    };
}
