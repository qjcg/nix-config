{
  pkgs,
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  name = "glooctl-${version}";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "solo-io";
    repo = "gloo";
    rev = "v${version}";

    # To get this value, use "nix-prefetch-url --unpack" with the release tarball, eg:
    #   nix-prefetch-url --unpack https://github.com/qjcg/4d/archive/v0.5.5.tar.gz
    sha256 = "06xwzm9b5wn3lhihbbx3m6k66y8dm11c6x3dpsh3f15kxwdjdqsb";
  };

  subPackages = [ "./projects/gloo/cli/cmd" ];

  postFixup = ''
    mv "$out"/bin/cmd "$out"/bin/glooctl
  '';

  # First, provide a fake hash via the value: lib.fakeSha256
  # Then, during build, copy "got" value in here.
  # Ref: https://discourse.nixos.org/t/how-to-create-modsha256-for-buildgomodule/3059/2
  #modSha256 = lib.fakeSha256;
  modSha256 = "0ww5c5ykjkrici68r6mkrpk18ljpp6l01x9916w2fr1kl1vwpb6c";

  meta = with lib; {
    description = "An Envoy-Powered API Gateway";
    homepage = https://github.com/solo-io/gloo ;
    license = licenses.asl20;
  };
}