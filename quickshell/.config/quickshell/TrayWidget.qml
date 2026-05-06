import QtQuick
import Quickshell.Services.SystemTray

Row {
	id: root
	spacing: 10

	Repeater {
		model: SystemTray.items || []

		Image {
			required property var modelData
			width: 13
			height: 13
			source: modelData.icon || ""
			fillMode: Image.PreserveAspectFit
			visible: source !== ""

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				cursorShape: Qt.PointingHandCursor
				onClicked: modelData.activate()
			}
		}
	}
}
