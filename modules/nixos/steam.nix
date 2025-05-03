{ lib, config, pkgs, ... }:

let
  cfg = config.steam;
in
{
  options.steam = {
    enable = lib.mkEnableOption "enable steam support";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    programs = {
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };
    hardware.xone.enable = true; # support for the xbox controller USB dongle
    environment = {
      systemPackages = pkgs.mangohud;
      loginShellInit = ''
        [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
      '';
    };
  };
}
