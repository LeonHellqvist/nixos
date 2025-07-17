# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, stylix, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
      ../modules/nixos/steam.nix
    ];

  #nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  steamClient = {
    enable = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "sv-latin1";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # exports keymaps
  services.xserver.exportConfiguration = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  
  services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.enable = true;

  services.displayManager.sddm.wayland.enable = true;

  services.blueman.enable = true;
  
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
    /* # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; */
  };

  fonts.fontDir.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];

  /* services.dnsmasq = {
    enable = true;
    settings = {
      interface = "wlp0s20f3";
      bind-interfaces = true;
      dhcp-range = "192.168.42.2,192.168.42.20,255.255.255.0,24h";
      dhcp-option = [
        "option:router,192.168.42.1"
        "option:dns-server,192.168.42.1"
      ];
    };
  }; */

  /* services.dnsmasq = {
    enable = true;
    # Let NetworkManager start dnsmasq instances as needed
    settings = {
      # Basic DNS settings
      domain-needed = true;
      bogus-priv = true;
      # Don't bind to specific interfaces, let NetworkManager control this
      # No interface-specific configuration here
    };
  }; */

  # Allow AP mode for your wireless card
  # networking.networkmanager.unmanaged = [ "interface-name:wlp0s20f3" ];  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "se";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.alsa.enablePersistence = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.resolved.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
    initialPassword = "changeme"; # Set a password for the user.
    packages = with pkgs; [
      tree
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs stylix; };
    users = {
      "leon" = import ../home.nix;
    };
  };

  services.gnome.sushi.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

  stylix.image = ./wallpapers/wallpaper1.png;

  stylix.enable = true;

  stylix.polarity = "dark";

  /* stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  }; */

  stylix.targets.gtk.enable = true;

  security.polkit.enable = true;

  programs.firefox.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pulseaudio
    alsa-utils
    pavucontrol
    nautilus
    pkgs.kitty
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    kdePackages.xdg-desktop-portal-kde
    mullvad-vpn
    git
    bzip2
    gzip
    p7zip 
    unrar 
    unzip 
    zip
    grim
    slurp
    wl-clipboard
    scrcpy
    pkgs.distrobox
    linux-wifi-hotspot
    wireguard-tools
    tor-browser-bundle-bin
    rustc
    cargo
  ];

  programs.nix-ld.enable = true;

  programs.file-roller.enable = true;

  #xdg = {
  #  autostart.enable = true;
  #};

  nix.extraOptions = ''
         extra-substituters = https://devenv.cachix.org
         extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
       '';

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.variables.EDITOR = "code --disable-gpu --wait";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
   # Did you read the comment?
}

