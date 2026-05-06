import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	property bool wifiConnected: false
	property int wifiSignal: 0
	property bool ethernetConnected: false
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"

	readonly property string icon: {
		if (ethernetConnected) return "󰀂"
		if (!wifiConnected) return "󰤮"
		if (wifiSignal >= 80) return "󰤨"
		if (wifiSignal >= 60) return "󰤥"
		if (wifiSignal >= 40) return "󰤢"
		if (wifiSignal >= 20) return "󰤟"
		return "󰤯"
	}

	text: icon

	Process {
		id: wifiProc
		command: ["sh", "-c", "nmcli -t -f ACTIVE,SSID,SIGNAL device wifi list | grep '^yes' | head -1"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data || !data.trim()) {
					root.wifiConnected = false
					root.wifiSignal = 0
					return
				}
				var parts = data.trim().split(':')
				if (parts.length >= 3) {
					root.wifiConnected = true
					root.wifiSignal = parseInt(parts[2]) || 0
				}
			}
		}
	}

	Process {
		id: ethProc
		command: ["sh", "-c", "nmcli -t -f TYPE,STATE device show | grep -E 'ethernet:connected' | head -1"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				root.ethernetConnected = data && data.includes("connected")
			}
		}
	}

	Timer {
		interval: 3000
		running: true
		repeat: true
		onTriggered: {
			wifiProc.running = true
			ethProc.running = true
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: 			Quickshell.execDetached([Quickshell.env("TERMINAL") || "foot", "--class=com.ghaerdi.Impala", "-e", "impala"])
	}
}
