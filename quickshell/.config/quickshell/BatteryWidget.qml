import QtQuick
import Quickshell.Io

Text {
	id: root
	property int capacity: 0
	property bool charging: false
	property bool critical: false
	property bool warning: false
	color: {
		if (root.critical && !root.charging) return colors.color5 || colors.foreground
		if (root.warning && !root.charging) return colors.color5 || colors.foreground
		return colors.foreground
	}
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"

	readonly property var chargingIcons: ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
	readonly property var defaultIcons: ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

	readonly property string icon: {
		if (root.charging) return root.chargingIcons[Math.min(9, Math.max(0, Math.floor(root.capacity / 10)))]
		if (root.capacity >= 100) return "󰂅"
		return root.defaultIcons[Math.min(9, Math.max(0, Math.floor(root.capacity / 10)))]
	}

	text: icon

	SequentialAnimation {
		running: root.critical && !root.charging
		loops: Animation.Infinite
		onStopped: root.opacity = 1.0
		NumberAnimation { target: root; property: "opacity"; from: 1.0; to: 0.0; duration: 500 }
		NumberAnimation { target: root; property: "opacity"; from: 0.0; to: 1.0; duration: 500 }
	}

	Process {
		id: capProc
		command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) root.capacity = parseInt(data.trim()) || 0
			}
		}
	}

	Process {
		id: statusProc
		command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Full"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (data) {
					var s = data.trim()
					root.charging = (s === "Charging" || s === "Full")
				}
			}
		}
	}

	Timer {
		interval: 5000
		running: true
		repeat: true
		onTriggered: {
			capProc.running = true
			statusProc.running = true
			root.warning = root.capacity <= 20 && root.capacity > 10
			root.critical = root.capacity <= 10
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
	}
}
