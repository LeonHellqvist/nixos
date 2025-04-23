{ pkgs, lib, inputs, ... }: {

  wayland.windowManager.hyprland = {
    # allow home-manager to configure hyprland
    enable = true;

    settings = {
      monitor = "DP-2, 3440x1440@143.97, 0x0, 1, vrr, 2";
      
      cursor = {
        "no_hardware_cursors" = true;
      };
     
      xwayland = {
        "force_zero_scaling" = true;
      };

      "exec-once" = [
        "systemctl --user start hyprpolkitagent"
        "waybar"
      ];

      input = {
        "accel_profile" = "flat";
        "follow_mouse" = "1";
        "force_no_accel" = "1";
        "kb_layout" = "se";
        "sensitivity" = "0.000000"; 
      };
    
      "$mainMod" = "SUPER";

      "$menu" = "sherlock";

      "$terminal" = "alacritty";

      "$fileManager" = "nautilus";

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, space, exec, $menu"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, movetoworkspace, 1"
        "$mainMod, 2, movetoworkspace, 2"
        "$mainMod, 3, movetoworkspace, 3"
        "$mainMod, 4, movetoworkspace, 4"
        "$mainMod, 5, movetoworkspace, 5"
        "$mainMod, 6, movetoworkspace, 6"
        "$mainMod, 7, movetoworkspace, 7"
        "$mainMod, 8, movetoworkspace, 8"
        "$mainMod, 9, movetoworkspace, 9"
        "$mainMod, 0, movetoworkspace, 10"

        "CTRL ALT, right, workspace, e+1"
        "CTRL ALT, left, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      animations = {
          "enabled" = "true";
          "bezier" = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };

      general = {
        "border_size" = "2";
        "gaps_in" = "4";
        "gaps_out" = "8";
      };

      decoration = {
        "rounding" = "10";
              
        "active_opacity" = "0.95";
        "inactive_opacity" = "0.8";
        "fullscreen_opacity" = "1.0";

        "dim_inactive" = "true";
        "dim_strength" = "0.05";
        "dim_special" = "0.8";

        shadow = {
          "enabled" = "true";
          "range" = "3";
          "render_power" = "1";
        };


        blur = {
          "enabled" = "true";	
          "size" = "7";
          "passes" = "2";
          "ignore_opacity" = "true";
          "new_optimizations" = "true";
          "special" = "true";
          "popups" = "true";
        };
      };
      env = [
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DISABLE_RDD_SANDBOX,1"
        "_JAVA_AWT_WM_NONREPARENTING=1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM,wayland"
        "LIBVA_DRIVER_NAME,nvidia"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "PROTON_ENABLE_NGX_UPDATER,1"
        "WLR_USE_LIBINPUT,1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"

        #"HYPRCURSOR_THEME,MyCursor"
        #"HYPRCURSOR_SIZE,24"
      ];
    };
  };
}
