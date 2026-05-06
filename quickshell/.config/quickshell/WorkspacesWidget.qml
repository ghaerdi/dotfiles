import QtQuick
import Quickshell
import Quickshell.Io

Text {
	id: root
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"

	readonly property var kanjiMap: ({
		1: "一", 2: "二", 3: "三", 4: "四", 5: "五",
		6: "六", 7: "七", 8: "八", 9: "九", 10: "十"
	})

	property int focusedIdx: 1

	text: kanjiMap[focusedIdx] ?? "一"

	Process {
		id: wsProcess
		running: true
		command: ["niri", "msg", "--json", "workspaces"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				try {
					const workspaces = JSON.parse(data)
					for (const ws of workspaces) {
						if (ws.is_focused) {
							root.focusedIdx = ws.idx
							return
						}
					}
				} catch (e) {}
			}
		}
	}

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: wsProcess.running = true
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(root.focusedIdx)])
	}
}
