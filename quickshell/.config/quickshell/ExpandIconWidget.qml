import QtQuick

Text {
	id: root
	color: colors.foreground
	font.pixelSize: 13
	font.family: "JetBrainsMono NL"
	text: ""

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
	}
}
