import QtQuick
import Quickshell.Io

Text {
	id: root
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"
	text: "0"

	Process {
		id: countProc
		command: ["sh", "-c", "niri msg --json windows | jq 'length'"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) root.text = data.trim()
			}
		}
	}

	Timer {
		interval: 5000
		running: true
		repeat: true
		onTriggered: countProc.running = true
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
	}
}
