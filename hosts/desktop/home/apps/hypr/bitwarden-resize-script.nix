pkgs:
pkgs.writeScript "hyprland-bitwarden-resize" ''
  #!/bin/sh

  handle() {
    case $1 in
      windowtitle*)
        window_id=''${1#*>>}

        # Get window info
        window_info=$(hyprctl clients -j | ${pkgs.jq}/bin/jq --arg id "0x$window_id" '.[] | select(.address == ($id))')
        window_title=$(echo "$window_info" | ${pkgs.jq}/bin/jq -r '.title // empty')

        # Precise match for the Bitwarden popup
        if [[ "$window_title" == *" (Bitwarden Password Manager) - Bitwarden"* ]]; then
          echo "Bitwarden popup detected (ID: 0x$window_id) - Making floating + resizing"

          hyprctl --batch "
            dispatch togglefloating address:0x$window_id;
            dispatch resizewindowpixel exact 560 780,address:0x$window_id;
            dispatch movewindowpixel exact 50% 20%,address:0x$window_id
          "
        fi
        ;;
    esac
  }

  # Listen to Hyprland events
  ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    handle "$line"
  done
''
