# Ref: https://nixos.org/nixpkgs/manual/#chap-overlays
[(self: super:

  {

    # Adding my own packages.
    go-4d = super.callPackage ./packages/4d {};
    barr = super.callPackage ./packages/barr {};
    mtlcam = super.callPackage ./packages/mtlcam {};
    horeb = super.callPackage ./packages/horeb {};

    # Adding 3rd-party packages.
    battery = super.callPackage ./packages/battery {};
    goplot = super.callPackage ./packages/goplot {};
    k3d = super.callPackage ./packages/k3d {};
    loccount = super.callPackage ./packages/loccount {};
    s-nail = super.callPackage ./packages/s-nail {};


    # Overriding existing packages.
    # Refs:
    #   - https://nixos.org/nixpkgs/manual/#sec-pkg-override
    #   - https://nixos.org/nixpkgs/manual/#sec-pkg-overrideAttrs

    dunst = super.dunst.override {
      dunstify = true;
    };

    # TODO: Figure out syntax for enabling various cores (below does NOT work).
    #retroarch = super.retroarch.override {
    #  cores = [
    #    fba
    #    genesis-plus-gx
    #    mame
    #    mupen64plus
    #    nestopia
    #    snes9x-next
    #    stella
    #  ];
    #};

    st = super.st.override {
      conf = builtins.readFile ./files/st-config.h;
    };

  }

)]
