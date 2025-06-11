{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./modules/home-manager/wm/hyprland.nix
    ./modules/home-manager/waybar.nix
    # ./modules/home-manager/sherlock.nix
    ./modules/home-manager/alacritty.nix
    inputs.zen-browser.homeModules.beta
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leon";
  home.homeDirectory = "/home/leon";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    vscode
    hyprpolkitagent
    hyprland-qt-support
    hyprpicker
    brightnessctl
    discord
    signal-desktop
    ungoogled-chromium

    github-desktop
    devenv
    direnv
    yaak
    slack
    inkscape
    wireguard-ui
    wireguard-tools

    monero-gui
    monero-cli

    protonup
    superTuxKart

    gthumb
    gimp3
    
    dunst
    libnotify

    font-awesome

    psst
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leon/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\\\${HOME}/.steam/root/compatibilitytools.d";
  };

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.kdePackages.xdg-desktop-portal-kde
        #inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      xdgOpenUsePortal = true;
      config = {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
          "org.freedesktop.impl.portal.Settings" = [
            "gnome"
          ];
          "org.freedesktop.portal.Settings" = [
            "gnome"
          ];
        };
      };
      #config.hyprland.default = [ "gnome" "gtk" "hyprland" "kde" ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 26;
  };

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    #font = {
    #  name = "Sans";
    #  size = 14;
    #};
  };

  #qt = {
  #  enable = true;
  #  platformTheme = "gnome";
  #  style.name = "adwaita-dark";
  #  style.package = pkgs.adwaita-qt;
  #};   
  home.sessionVariables.GTK_THEME = "adw-gtk3-dark";

  services.dunst = {
    enable = true;

    settings = {
      # ... dunstrc items
    };
  };

  programs.zen-browser = {
    enable = true;
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      # find more options here: https://mozilla.github.io/policy-templates/
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
