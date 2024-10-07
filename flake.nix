{
  description = "OpenSSL GOST Nix";

  inputs = {
    # Official NixOS repo
    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Current nixpkgs branch
    nixpkgs = {
      follows = "unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { self', pkgs, ... }: {
        packages = {
          openssl-gost-engine = pkgs.callPackage ./pkgs/gost-engine.nix {};
          openssl = pkgs.callPackage ./pkgs/openssl.nix { openssl-gost-engine = self'.packages.openssl-gost-engine; };
          curl = pkgs.callPackage ./pkgs/curl.nix { openssl = self'.packages.openssl; };
        };
      };
    };
}

