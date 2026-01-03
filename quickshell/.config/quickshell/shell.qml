import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Io
import Quickshell.Hyprland 
import Quickshell.Wayland 
//
ShellRoot {
	FileView {
		id: wal
		path: Quickshell.env("HOME") + "/.cache/wal/colors.json"

		JsonAdapter {
			property var colors: ({}) 
		}
	}
	property var styles: new Object({ radius: 15, color: wal.adapter.colors.color0 })
	property var panels: new Object({ left: 10, right: 10, top: 0, bottom: 10 })

	Item {
		anchors.fill: parent
		layer.enabled: true

		PanelWindow {
			anchors { top: true; left: true; right: true; }
			height: panels.top;
			color: styles.color;
		}

		PanelWindow {
			anchors { bottom: true; left: true; right: true; }
			height: panels.bottom;
			color: styles.color;
		}

		PanelWindow {
			anchors { left: true; top: true; bottom: true; }
			width: panels.left;
			color: styles.color;
		}

		PanelWindow {
			anchors { right: true; top: true; bottom: true; }
			width: panels.right;
			color: styles.color;
		}

		PanelWindow {
			anchors { top: true; bottom: true; left: true; right: true }
			aboveWindows: false
			surfaceFormat.opaque: false
			color: "transparent"

			mask: Region {
				item: mask
				intersection: Intersection.Xor
			}

			Item {
				anchors.fill: parent

				Rectangle {
					anchors.fill: parent
					color: styles.color;

					layer.enabled: true
					layer.effect: MultiEffect {
							maskSource: mask
							maskEnabled: true
							maskInverted: true
							maskThresholdMin: 0.5
							maskSpreadAtMin: 1
					}
				}

				Item {
					id: mask

					anchors.fill: parent
					layer.enabled: true
					visible: false

					Rectangle {
						anchors.fill: parent
						radius: styles.radius
					}
				}
			}
		}
	}
}
