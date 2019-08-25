{
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  name = "barr-${version}";
  version = "1.13.0";

  subPackages = [ "cmd/barr" ];

  src = fetchFromGitHub {
    owner = "qjcg";
    repo = "barr";
    rev = "v${version}";

    # To get this value, use "nix-prefetch-url --unpack" with the release tarball, eg:
    #   nix-prefetch-url --unpack https://github.com/qjcg/4d/archive/v0.5.5.tar.gz
    sha256 = "19fl8wrhclayfj3f97zdnwqy6b1xj12x08x51xz90rf2j5f4lvr9";
  };

  # First, provide a fake hash via the value: lib.fakeSha256
  # Then, during build, copy "got" value in here.
  # Ref: https://discourse.nixos.org/t/how-to-create-modsha256-for-buildgomodule/3059/2
  modSha256 = "0l7vj9b7j3mp0llhhhs47jmfzr5i343kkxc1n7blhmbddgdqrgpx";

  meta = with lib; {
    description = "A simple statusbar.";
    homepage = https://github.com/qjcg/barr;
    license = licenses.mit;
  };
}
