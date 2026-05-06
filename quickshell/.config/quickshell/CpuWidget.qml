import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	property int usage: 0
	property var lastIdle: 0
	property var lastTotal: 0
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"
	text: ""

	Process {
		id: cpuProc
		command: ["sh", "-c", "head -1 /proc/stat"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var parts = data.trim().split(/\s+/)
				var user = parseInt(parts[1]) || 0
				var nice = parseInt(parts[2]) || 0
				var system = parseInt(parts[3]) || 0
				var idle = parseInt(parts[4]) || 0
				var iowait = parseInt(parts[5]) || 0
				var irq = parseInt(parts[6]) || 0
				var softirq = parseInt(parts[7]) || 0
				var total = user + nice + system + idle + iowait + irq + softirq
				var idleTime = idle + iowait
				if (root.lastTotal > 0) {
					var totalDiff = total - root.lastTotal
					var idleDiff = idleTime - root.lastIdle
					if (totalDiff > 0) root.usage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
				}
				root.lastTotal = total
				root.lastIdle = idleTime
			}
		}
	}

	Timer {
		interval: 10000
		running: true
		repeat: true
		onTriggered: cpuProc.running = true
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: 			Quickshell.execDetached([Quickshell.env("TERMINAL") || "foot", "--class=com.ghaerdi.Btop", "-e", "btop"])
	}
}
