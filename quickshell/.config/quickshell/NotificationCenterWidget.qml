import QtQuick
import Quickshell

Text {
	id: root
	color: colors.foreground
	font.pixelSize: 20
	font.family: "JetBrainsMono NL"
	text: ""

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: 			Quickshell.execDetached(["swaync-client", "-t"])
	}
}
