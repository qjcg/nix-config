{
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  name = "barr-${version}";
  version = "1.12.1";

  subPackages = [ "cmd/barr" ];

  src = fetchFromGitHub {
    owner = "qjcg";
    repo = "barr";
    rev = "v${version}";

    # To get this value, use "nix-prefetch-url --unpack" with the release tarball, eg:
    #   nix-prefetch-url --unpack https://github.com/qjcg/4d/archive/v0.5.5.tar.gz
    sha256 = "0i36sj4ql5rxw20302fa3q677hy5v5xfm4sc2bxakj2nbpmrjgir";
  };

  # First, provide a fake hash via the value: lib.fakeSha256
  # Then, during build, copy "got" value in here.
  # Ref: https://discourse.nixos.org/t/how-to-create-modsha256-for-buildgomodule/3059/2
  modSha256 = "1db51knszhv84y2c231znbh4rx7xs577nmm8y4yc725lxr6d40aw";

  meta = with lib; {
    description = "A simple statusbar.";
    homepage = https://github.com/qjcg/barr;
    license = licenses.mit;
  };
}