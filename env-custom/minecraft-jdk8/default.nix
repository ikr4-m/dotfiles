{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  name = "ENV";
  packages = with pkgs; [
    jdk8
  ];
}
