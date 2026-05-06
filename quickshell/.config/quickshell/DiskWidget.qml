import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	property real freeGB: 0
	property real totalGB: 0
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"
	text: "⛃"

	Process {
		id: diskProc
		command: ["sh", "-c", "df -BG / | tail -1"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var parts = data.trim().split(/\s+/)
				if (parts.length >= 4) {
					root.totalGB = parseFloat(parts[1].replace('G', '')) || 0
					root.freeGB = parseFloat(parts[3].replace('G', '')) || 0
				}
			}
		}
	}

	Timer {
		interval: 30000
		running: true
		repeat: true
		onTriggered: diskProc.running = true
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: 			Quickshell.execDetached([Quickshell.env("TERMINAL") || "foot", "--class=com.ghaerdi.Dust", "-e", "sh", "-c", "dust /; read"])
	}
}
