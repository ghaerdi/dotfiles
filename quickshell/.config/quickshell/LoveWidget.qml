import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	color: colors.foreground
	font.pixelSize: 11
	font.family: "JetBrainsMono NL"
	text: ""

	Process {
		id: loveProc
		command: ["bun", Quickshell.env("HOME") + "/dotfiles/polybar/.config/polybar/scripts/love.ts"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) root.text = data.trim() + " 󰩗 "
			}
		}
	}

	Timer {
		interval: 60000
		running: true
		repeat: true
		onTriggered: loveProc.running = true
	}
}
