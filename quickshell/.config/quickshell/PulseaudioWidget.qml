import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	property int volume: 0
	property bool muted: false
	property string sinkType: "default"
	color: root.muted ? (colors.color6 || colors.foreground) : colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"

	readonly property var defaultIcons: ["", "", ""]
	readonly property string icon: {
		if (root.muted) return ""
		if (root.sinkType === "bluetooth") return "󰂰"
		if (root.volume < 30) return defaultIcons[0]
		if (root.volume < 70) return defaultIcons[1]
		return defaultIcons[2]
	}

	text: icon

	Process {
		id: volProc
		command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var match = data.match(/Volume:\s*([\d.]+)/)
				if (match) root.volume = Math.round(parseFloat(match[1]) * 100)
				root.muted = data.includes("[MUTED]")
			}
		}
	}

	Process {
		id: sinkProc
		command: ["wpctl", "inspect", "@DEFAULT_AUDIO_SINK@"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var sink = data.toLowerCase()
				if (sink.includes("headphone") || sink.includes("headset")) root.sinkType = "headphones"
				else if (sink.includes("bluez") || sink.includes("bluetooth")) root.sinkType = "bluetooth"
				else if (sink.includes("hdmi")) root.sinkType = "hdmi"
				else root.sinkType = "default"
			}
		}
	}

	Timer {
		interval: 2000
		running: true
		repeat: true
		onTriggered: {
			volProc.running = true
			sinkProc.running = true
		}
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
		onClicked: mouse => {
			if (mouse.button === Qt.LeftButton) {
				Quickshell.execDetached([Quickshell.env("TERMINAL") || "foot", "--class=com.ghaerdi.Wiremix", "-e", "wiremix"])
			} else if (mouse.button === Qt.RightButton) {
				Quickshell.execDetached(["pavucontrol"])
			} else if (mouse.button === Qt.MiddleButton) {
				Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
			}
		}
	}
}
