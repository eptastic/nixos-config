{...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display
      };
      listener = [
        {
          # Dim Screen
          timeout = 150; # 2.5m
          on-timeout = "brightnessctl -s set 10"; # Set backlight to min.
          on-resume = "brightnessctl -r";
        }
        {
          # Lock
          timeout = 300; #5m
          on-timeout = "loginctl lock-session"; #lock screen when timeout has passed
        }
        {
          # Suspend
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
