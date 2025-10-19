{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "vanzuh-volume" ''
      #!/bin/sh

      notification_timeout=1000
      step=5

      get_volume() {
      	${pkgs.pamixer}/bin/pamixer --get-volume
      }

      get_mute_status() {
      	${pkgs.pamixer}/bin/pamixer --get-mute
      }

      get_icon() {
      	if [ "$(get_mute_status)" = "true" ]; then
      		echo "/home/vanzuh/dotfiles/nixconf/assets/icons/volume-muted.svg"
      	else
      		volume=$(get_volume)
      		if [ $volume -eq 0 ]; then
      			echo "/home/vanzuh/dotfiles/nixconf/assets/icons/volume-no-sound.svg"
      		elif [ $volume -le 33 ]; then
      			echo "/home/vanzuh/dotfiles/nixconf/assets/icons/volume-low.svg"
      		else
      			echo "/home/vanzuh/dotfiles/nixconf/assets/icons/volume-high.svg"
      		fi
      	fi
      }

      notify_user() {
      	icon=$(get_icon)
      	if [ "$(get_mute_status)" = "true" ]; then
      		${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -i "$icon" -h string:x-canonical-private-synchronous:volume "Audio" "Muted"
      	else
      		volume=$(get_volume)
      		${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -i "$icon" -h string:x-canonical-private-synchronous:volume -h int:value:$volume "Audio" "Volume: $volume%"
      	fi
      }

      change_volume() {
      	direction=$1
      	notify_flag=$2
      	case $direction in
      		up|+)
      			${pkgs.pamixer}/bin/pamixer --increase $step
      			if [ "$notify_flag" = "--notify" ]; then
      				notify_user
      			fi
      			;;
      		down|-)
      			${pkgs.pamixer}/bin/pamixer --decrease $step
      			if [ "$notify_flag" = "--notify" ]; then
      				notify_user
      			fi
      			;;
      		get)
      			if [ "$(get_mute_status)" = "true" ]; then
      				echo "Muted"
      			else
      				echo "$(get_volume)%"
      			fi
      			;;
      		status)
      			if [ "$(get_mute_status)" = "true" ]; then
      				echo "muted"
      			else
      				echo "unmuted"
      			fi
      			;;
      		toggle|mute)
      			${pkgs.pamixer}/bin/pamixer --toggle-mute
      			if [ "$notify_flag" = "--notify" ]; then
      				notify_user
      			fi
      			;;
      		*)
      			echo "Usage: $0 {up|down|+|-|get|status|toggle|mute} [--notify]"
      			exit 1
      			;;
      	esac
      }

      change_volume "$1" "$2"
    '')
  ];
}
