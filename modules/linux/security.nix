{ config, pkgs, ... }:

{
  config = {
    security.sudo.wheelNeedsPassword = false;
  };
}
