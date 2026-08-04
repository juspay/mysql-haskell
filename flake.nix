{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/89c2b2330e733d6cdb5eae7b899326930c2c0648";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    tcp-streams={
      type="git";
      url="https://github.com/infinitumkiran/tcp-streams";
      ref="ghc984";
      rev="b4a535c013714cdad12d83772ffc7634deff97c1";
      };
    word24.url = "github:winterland1989/word24";
    word24.flake = false;
    ram.url = "github:jappeace/ram";
    ram.flake = false;
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
          basePackages = pkgs.haskell.packages.ghc98;

          packages = {
            word24.source = inputs.word24;
            tcp-streams.source = inputs.tcp-streams;
            ram.source = inputs.ram;
            regex-tdfa.source="1.3.2.5";
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
              broken=false;
            };
            tcp-streams = {
              check = false;
            };
            mysql-haskell = {
              check = false;
            };
          };

          autoWire = [ "packages" "checks" "devShells" "apps"];
        };
      packages.default = self'.packages.mysql-haskell;
      };
    });
}
