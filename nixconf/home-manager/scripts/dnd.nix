{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-dnd" ''
      #!/bin/sh

      get_dnd_status() {
      	${pkgs.swaynotificationcenter}/bin/swaync-client --get-dnd
      }

      toggle_dnd() {
      	${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd
      }

      set_dnd_on() {
      	${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-on
      }

      set_dnd_off() {
      	${pkgs.swaynotificationcenter}/bin/swaync-client --dnd-off
      }

      case "$1" in
      	toggle)
      		toggle_dnd
      		;;
      	status|get)
      		get_dnd_status
      		;;
      	on)
      		set_dnd_on
      		;;
      	off)
      		set_dnd_off
      		;;
      	*)
      		echo "Usage: $0 {toggle|status|get|on|off}"
      		echo ""
      		echo "Commands:"
      		echo "  toggle    Toggle DND on/off and show new state"
      		echo "  status    Show current DND status"
      		echo "  get       Alias for status"
      		echo "  on        Turn DND on"
      		echo "  off       Turn DND off"
      		exit 1
      		;;
      esac
    '')
  ];
}
