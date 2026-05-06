import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	property bool powered: false
	property bool connected: false
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"

	readonly property string icon: {
		if (!root.powered) return "󰂲"
		if (root.connected) return ""
		return ""
	}

	text: icon

	Process {
		id: statusProc
		command: ["sh", "-c", "bluetoothctl show | grep Powered"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) root.powered = data.includes("yes")
			}
		}
	}

	Process {
		id: connProc
		command: ["sh", "-c", "bluetoothctl info 2>/dev/null | grep Connected | head -1"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) root.connected = data.includes("yes")
			}
		}
	}

	Timer {
		interval: 5000
		running: true
		repeat: true
		onTriggered: {
			statusProc.running = true
			connProc.running = true
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: 			Quickshell.execDetached([Quickshell.env("TERMINAL") || "foot", "--class=com.ghaerdi.Bluetui", "-e", "bluetui"])
	}
}
