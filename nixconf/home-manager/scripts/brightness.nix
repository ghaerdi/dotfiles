{
  config,
  pkgs,
  homeDirectory,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-brightness" ''
      #!/bin/sh
      notification_timeout=1000
      step=5

      get_brightness() {
      	${pkgs.brightnessctl}/bin/brightnessctl -m | cut -d, -f4 | sed 's/%//'
      }

      get_icon() {
      	brightness=$1
      	if [ $brightness -le 33 ]; then
      		echo "${homeDirectory}/dotfiles/nixconf/assets/icons/brightness-down.svg"
      	elif [ $brightness -le 66 ]; then
      		echo "${homeDirectory}/dotfiles/nixconf/assets/icons/brightness-middle.svg"
      	else
      		echo "${homeDirectory}/dotfiles/nixconf/assets/icons/brightness-up.svg"
      	fi
      }

      notify_user() {
      	brightness=$(get_brightness)
      	icon=$(get_icon $brightness)
      	${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -i "$icon" -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness "Screen" "Brightness: $brightness%"
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
