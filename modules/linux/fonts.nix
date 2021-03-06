# Linux font configuration.
{ config, pkgs, ... }:

let
  inherit (import ../vars/fonts.nix { inherit pkgs; }) fontPkgs;
in
{
  config = {

    fonts = {
      fonts = fontPkgs;
      enableDefaultFonts = true;
      fontDir.enable = true;

      fontconfig.enable = true;
      fontconfig.defaultFonts = {
        emoji = [ "Noto Color Emoji" "Noto Emoji" "Unifont" ];
        monospace = [ "JuliaMono" "Iosevka" "Victor Mono" "Go Mono" "Unifont" ];
        sansSerif = [ "Noto Sans" "Roboto Medium" "Unifont" ];
        serif = [ "Noto Serif" "Roboto Slab" "Unifont" ];
      };
    };

  };
}
