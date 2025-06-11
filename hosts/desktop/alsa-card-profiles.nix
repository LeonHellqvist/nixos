{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "my-alsa-card-profiles";
  version = "1.0";

  src = ./nari-alsa-profiles;

  installPhase = ''
    mkdir -p $out/share/alsa-card-profile
    cp -r $src/* $out/share/alsa-card-profile/
  '';

  meta = with lib; {
    description = "Custom ALSA card profiles for PipeWire";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
