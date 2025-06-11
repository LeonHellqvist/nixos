# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, stylix, ... }:

let
  myALSAProfiles = pkgs.callPackage ./alsa-card-profiles.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./modules/nixos/nvidia.nix
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nvidia = {
    enable = true;
  };

  networking.hostName = "desktop"; # Define your hostname.

  networking.networkmanager.insertNameservers = [ "192.168.1.63" ];
}

