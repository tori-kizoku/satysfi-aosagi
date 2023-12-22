{
  description = "The SATySFi classfile for me";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
    satyxin.url = "github:SnO2WMaN/satyxin";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    satyxin,
    naersk,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            satyxin.overlays.default
          ];
        };
        naersk' = pkgs.callPackage naersk {};
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            ocaml
            opam
            ocamlPackages.ocaml-lsp
            ocamlPackages.ocamlformat
            nil
            alejandra
            satysfi
            treefmt
            (naersk'.buildPackage {
              src = pkgs.fetchFromGitHub {
                owner = "monaqa";
                repo = "satysfi-language-server";
                rev = "1ce6bc4d08eb748aeb10f69498e4a16f01978535";
                sha256 = "sha256-4EmLDsCrJXzQb72JrGGPR7+gAQKcniVGrBnrl9JanBs=";
              };
            })
            (naersk'.buildPackage {
              src = pkgs.fetchFromGitHub {
                owner = "usagrada";
                repo = "satysfi-formatter";
                rev = "a36ec28f3e4354dd0b0bec938a507d853fcb19e7";
                sha256 = "sha256-a2meR+4OnJkXzr4vqbTToZ9s2aXarKIRtqLUyALYVyQ=";
              };
            })
          ];
        };
      }
    );
}
