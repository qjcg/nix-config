{
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,

  upx,
}:

buildGoModule rec {
  name = "barr-${version}";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "qjcg";
    repo = "barr";
    rev = "v${version}";

    # To get this value, use "nix-prefetch-url --unpack" with the release tarball, eg:
    #   nix-prefetch-url --unpack https://github.com/qjcg/4d/archive/v0.5.5.tar.gz
    sha256 = "1r4sf3wrhdvbxv8wp9597hxindsqzffzkpqs6vb5b6x4x4mlhdxg" ;
  };

  subPackages = [ "cmd/barr" ];
  buildInputs = [ upx ];
  fixupPhase = '' upx $out/bin/* '';

  # First, provide a fake hash via the value: lib.fakeSha256
  # Then, during build, copy "got" value in here.
  # Ref: https://discourse.nixos.org/t/how-to-create-modsha256-for-buildgomodule/3059/2
  modSha256 = "1n9rcjbmfcw4n8bdr93wvh8cgbqsyxr0w902k638ykz9lgx94kvp" ;

  meta = with lib; {
    description = "A simple statusbar.";
    homepage = https://github.com/qjcg/barr;
    license = licenses.mit;
  };
}
