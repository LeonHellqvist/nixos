{ config, lib, pkgs, ...}:

let
  my-rules = pkgs.writeTextFile {
    name = "91-pulseaudio-razer-nari.rules";
    text = ''
      ATTRS{idVendor}=="1532", ATTRS{idProduct}=="051a", ENV{ACP_PROFILE_SET}="razer-nari-usb-audio.conf"
      ATTRS{idVendor}=="1532", ATTRS{idProduct}=="051c", ENV{ACP_PROFILE_SET}="razer-nari-usb-audio.conf"
      ATTRS{idVendor}=="1532", ATTRS{idProduct}=="051d", ENV{ACP_PROFILE_SET}="razer-nari-usb-audio.conf"
    '';
    destination = "/etc/udev/rules.d/91-pulseaudio-razer-nari.rules";
  };
in {
...
   services.udev.packages = [ my-rules ];
}