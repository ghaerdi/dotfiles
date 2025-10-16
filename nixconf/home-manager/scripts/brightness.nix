{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "vanzuh-brightness" ''
      #!/bin/sh
      notification_timeout=1000
      step=5

      get_brightness() {
      	${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d, -f4 | sed 's/%//'
      }

      notify_user() {
      	brightness=$(get_brightness)
      	${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness "Screen" "Brightness: $brightness%"
      }

      change_brightness() {
      	direction=$1
      	notify_flag=$2
      	case $direction in
      		up|+)
      			${pkgs.brightnessctl}/bin/brightnessctl set +$step%
      			if [ "$notify_flag" = "--notify" ]; then
      				notify_user
      			fi
      			;;
      		down|-)
      			${pkgs.brightnessctl}/bin/brightnessctl set $step%-
      			if [ "$notify_flag" = "--notify" ]; then
      				notify_user
      			fi
      			;;
      		get)
      			echo "$(get_brightness)%"
      			;;
      		*)
      			echo "Usage: $0 {up|down|+|-|get} [--notify]"
      			exit 1
      			;;
      	esac
      }

      change_brightness "$1" "$2"
    '')
  ];
}
