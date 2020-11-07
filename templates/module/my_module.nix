{ pkgs ? "github:nixos/nixpkgs/nixpkgs-unstable", ... }:

with pkgs.lib;
{
  options = {
    roles.demo.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable demo mode";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [ htop ];
  };
}