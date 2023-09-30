{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";

    word24.url = "github:winterland1989/word24";
    word24.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.haskell-flake.flakeModule
      ];
      perSystem = { self', pkgs, lib, config, ... }: {
        haskellProjects.default = {
          projectFlakeName = "mysql-haskell";
          basePackages = pkgs.haskell.packages.ghc927;

          packages = {
            word24.source = inputs.word24;
          };

          settings = {
            word24 = {
              check = false;
              broken = false;
              jailbreak = true;
            };
            binary-parsers = {
              broken = false;
              jailbreak = true;
            };
            wire-streams = {
              jailbreak = true;
            };
          };

          autoWire = [ "packages" "checks" "devShells" "apps"];
        };
      };
    });
}
