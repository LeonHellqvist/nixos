{ inputs, ... }:
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;

      # theme = "gruvbox_split";

      layout = {
        "bar.layouts" = {
          "0" = {
            left = [ "dashboard" "workspaces" ];
            middle = [ "media" ];
            right = [ "clock" "cpu" "ram" "volume" "network" "bluetooth" "systray" "notifications" "battery"  ];
          };
        };
      };

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.enabled = false;
      };

      bar.autoHide = "never";

      bar.clock.format = "%H:%M";

      scalingPriority = "hyprland";

      menus.dashboard.directories.enabled = false;

      theme.font = {
        name = "CaskaydiaCove NF";
        size = "13px";
      };
    };
  };
}
