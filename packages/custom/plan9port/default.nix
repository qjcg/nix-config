{ lib
, stdenv
, fetchFromGitHub
, which
, darwin ? null
, xorgproto ? null
, libX11
, libXext ? null
, libXt ? null
, fontconfig ? null
, freetype ? null
, perl ? null # For building web manuals
}:
let
  inherit (lib) licenses maintainers optionals optionalString platforms;
  inherit (stdenv) isDarwin mkDerivation;
  version = "2020-02-22";
in
mkDerivation {
  inherit version;
  pname = "plan9port";

  src = fetchFromGitHub {
    owner = "9fans";
    repo = "plan9port";
    rev = "0237dec768a4ee36ae9e18ce8566d2c999d78410";
    sha256 = "104wvib6x00hjjm7cf6krjnkk4j3qifzyf5ysjqh723nisnphg2v";
  };

  #patches = [
  #  ./tmpdir.patch
  #  ./darwin-sw_vers.patch
  #  ./darwin-cfframework.patch
  #];

  postPatch = ''
    #hardcoded path
    substituteInPlace src/cmd/acme/acme.c \
      --replace /lib/font/bit $out/plan9/font

    #deprecated flags
    find . -type f \
      -exec sed -i -e 's/_SVID_SOURCE/_DEFAULT_SOURCE/g' {} \; \
      -exec sed -i -e 's/_BSD_SOURCE/_DEFAULT_SOURCE/g' {} \;

    substituteInPlace bin/9c \
      --replace 'which uniq' '${which}/bin/which uniq'
  '' + optionalString (!isDarwin) ''
    #add missing ctrl+c\z\x\v keybind for non-Darwin
    substituteInPlace src/cmd/acme/text.c \
      --replace "case Kcmd+'c':" "case 0x03: case Kcmd+'c':" \
      --replace "case Kcmd+'z':" "case 0x1a: case Kcmd+'z':" \
      --replace "case Kcmd+'x':" "case 0x18: case Kcmd+'x':" \
      --replace "case Kcmd+'v':" "case 0x16: case Kcmd+'v':"
  '';

  buildInputs = [ perl ] ++ optionals (!isDarwin) [
    xorgproto
    libX11
    libXext
    libXt
    fontconfig
    freetype # fontsrv wants ft2build.h provides system fonts for acme and sam.
  ] ++ optionals isDarwin
    (with darwin.apple_sdk.frameworks; [ Carbon Cocoa IOKit Metal QuartzCore ]);

  builder = ./builder.sh;
  libXt_dev = libXt.dev;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/9 rc -c 'echo rc is working.'

    # 9l can find and use its libs
    cd $TMP
    cat >test.c <<EOF
    #include <u.h>
    #include <libc.h>
    #include <thread.h>
    void
    threadmain(int argc, char **argv)
    {
        threadexitsall(nil);
    }
    EOF
    $out/bin/9 9c -o test.o test.c
    $out/bin/9 9l -o test test.o
    ./test
  '';

  meta = {
    homepage = "https://9fans.github.io/plan9port/";
    description = "Plan 9 from User Space";
    longDescription = ''
      Plan 9 from User Space (aka plan9port) is a port of many Plan 9 programs
      from their native Plan 9 environment to Unix-like operating systems.
    '';
    license = licenses.lpl-102;
    maintainers = with maintainers; [
      AndersonTorres
      bbarker
      ftrvxmtrx
      kovirobi
    ];
    platforms = platforms.unix;
  };
}
# TODO: investigate the mouse chording support patch
