# Example from: https://www.tweag.io/blog/2020-05-25-flakes/
{
  description = "A flake providing single package (and setting defaultPackage).";

  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, pkgs }:
    {
      defaultPackage.x86_64-linux =
        with import pkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation {
          name = "hello";
          src = self;
          buildPhase = "gcc -o hello ./hello.c";
          installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
        };
    };
}