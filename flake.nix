{
  description = "Renovate flake test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    utils.url = "github:numtide/flake-utils";
    yarn2nix.url = "github:input-output-hk/yarn2nix";
    sbt-hook = {
      url = "github:MonikaJassova/sbt-nix?dir=sbt-hook";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
    midnight-e2e-tests = {
      url = "github:input-output-hk/midnight-e2e-tests";
      inputs.utils.follows = "utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    yarn2nix,
    utils,
    sbt-hook,
    midnight-e2e-tests,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system}.extend yarn2nix.overlay;
        sbt = sbt-hook.packages.${system}.default;
      in
        rec {
          # nix develop shell
          devShells.default = pkgs.mkShell {
            packages = [pkgs.nodejs-16_x pkgs.yarn pkgs.which sbt pkgs.cargo];
          };
        }
    );
}
