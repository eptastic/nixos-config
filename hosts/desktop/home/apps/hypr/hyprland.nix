{
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = ''
      exec-once = ${pkgs.swww}/bin/swww-daemon
      exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet --indicator
      exec-once = ${pkgs.waybar}/bin/waybar

      exec-once = sleep 1 && ${pkgs.swww}/bin/swww img ${config.home.homeDirectory}/nixos-config/assets/wallpaper/space_brown_hues.jpg
    '';

    settings = {
      "$terminal" = "wezterm";
      "$fileManager" = "yazi";
      "$menu" = "wofi --show drun";
      "$mainMod" = "SUPER";
      # Screenshots Directory
      "$ssDir" = "/home/alex/Pictures/Screenshots";

      monitor = [
        "DP-2,2560x1440@164.85,0x0,1"
      ];
      env = [
        "XDG_CURRENT_DESKTOP=Hyprland"
        "QT_QPA_PLATFORM=wayland:xcb"
        "WLR_NO_HARDWARE_CURSORS=1"
        "HYPRCURSOR_THEME=Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE=24"
      ];
      exec-once = [
        # Set Autostart Applications
        "hyprctl dispatch exec [workspace 1] firefox"
        "hyprctl dispatch exec [workspace 1] wezterm"
        # "hyprctl dispatch exec [workspace 2] obsidian"
        #	"sleep 30 && hyprctl dispatch exec [workspace 3] discord"
        #	"hyprctl dispatch exec [workspace 4] spotify"
        # "sleep 30 && hyprctl dispatch exec [workspace 5] nextcloud-client"
        #	"hyprctl dispatch exec [workspace 6] thunderbird"
        # Set Bitwarden to floating window
        ## See https://github.com/hyprwm/Hyprland/issues/3835 for explaination (also contains NixOS config)
        "$HOME/.local/share/scripts/hyprland-bitwarden-resize.sh"
        "hypridle"
        "bash ~/.config/hypr/start.sh"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 to 1.0, 0 means no modification.
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        ## Overwritten by Stylix I believe, so not necessary
        #"col.active_border" = "rgba(458588ee) rgba(689d6aee) 45deg";
        #"col.inactive_border" = "rgba(a89984aa)";
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        #new_is_master = true
      };

      # gestures = {
      #   # See https://wiki.hyprland.org/Configuring/Variables/ for more
      #   workspace_swipe = false;
      # };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      };

      windowrulev2 = [
        # Set bordercolor to red if window is fullscreen
        "bordercolor rgb(cc241d) rgb(880808),fullscreen:1"

        # Suppress Firefox maximize animation
        "suppressevent maximize,class:^(firefox)$"

        # Set Pavucontrol and other windows to float
        "float,class:pavucontrol"
        "float,title:swappy"
        "float,title:Syncthing"

        # Firefox Picture-in-Picture window tweaks
        "size 640 360,title:(Picture-in-Picture)"
        "pin,title:^(Picture-in-Picture)$"
        "move 960 520,title:(Picture-in-Picture)"
        "float,title:^(Picture-in-Picture)$"
      ];

      bind = [
        "$mainMod, L, exec, pidof hyprlock || hyprlock"

        # Opens the Rofi Launcher
        "$mainMod, D, exec, rofi -show drun -show-icons"

        # Screenshot command, the copying to the clipboard doesn't work
        ", Print, exec, grim -g '$(slurp)' - | tee >(wl-copy && notify-send 'Screenshot copied to clipboard' -t 1000) > /home/alex/Pictures/Screenshots/Screenshot-$(date +%F_%T).png && notify-send 'Screenshot saved to /home/alex/Pictures/Screenshots' -t 1000"
        "SHIFT, Print, exec, grim -g '$(slurp)' - | swappy -f -"

        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, C, killactive, "
        #				"$mainMod, M, exit, "
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating, "
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, F, fullscreen, 1"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Move active window to another direction
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        #"$mainMod, mouse:273, resizewindow"

        # Resize Windows with keys
        "$mainMod CTRL SHIFT, right, resizeactive, 50 0"
        "$mainMod CTRL SHIFT, left, resizeactive, -50 0"
        "$mainMod CTRL SHIFT, up, resizeactive, 0 -50"
        "$mainMod CTRL SHIFT, down, resizeactive, 0 50"

        # Resize incrementally
        "$mainMod CTRL SHIFT ALT, right, resizeactive, 10 0"
        "$mainMod CTRL SHIFT ALT, left, resizeactive, -10 0"
        "$mainMod CTRL SHIFT ALT, up, resizeactive, 0 -10"
        "$mainMod CTRL SHIFT ALT, down, resizeactive, 0 10"
      ];
    };
  };
}
