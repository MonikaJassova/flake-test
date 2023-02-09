{
  description = "Renovate flake test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.08";
    utils.url = "github:numtide/flake-utils";
    yarn2nix.url = "github:input-output-hk/yarn2nix";
  };

  outputs = {
    self,
    nixpkgs,
    yarn2nix,
    utils,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system}.extend yarn2nix.overlay;
      in
        rec {
          defaultPackage = packages.flake-test;

          # nix develop shell
          devShells.default = pkgs.mkShell {
            packages = [pkgs.nodejs-16_x pkgs.yarn pkgs.which];
          };
        }
    );
}
