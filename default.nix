# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  picoforge = pkgs.callPackage ./pkgs/picoforge { };
  subplot = pkgs.callPackage ./pkgs/subplot { };
  ambient-ci = pkgs.callPackage ./pkgs/ambient-ci { };
  radicle-ci-ambient = pkgs.callPackage ./pkgs/radicle-ci-ambient { };
}
