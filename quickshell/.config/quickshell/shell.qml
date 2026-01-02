import Quickshell
import QtQuick
import QtQuick.Effects // Requires qml6-module-qtquick-effects
import Quickshell.Io
import Quickshell.Hyprland 
import Quickshell.Wayland 

Scope {
	WlrLayershell.namespace: "quickshell-border";
	FileView {
			id: wal
			// The path goes here, NOT in the JsonAdapter
			path: Quickshell.env("HOME") + "/.cache/wal/colors.json"

			// 2. The adapter parses the content
			JsonAdapter {
					// This property matches the "colors" key in Pywal's JSON
					// Using 'var' allows it to hold the entire sub-object of colors
					property var colors: ({}) 
					
					// Optional: You can also grab the wallpaper path
					property string wallpaper: ""
			}
	}

	PanelWindow {
		anchors { bottom: true; left: true; right: true; }
		height: 15;
		color: wal.adapter.colors.color0;
		HyprlandWindow.opacity: 0.8;
		WlrLayershell.namespace: "quickshell-border";
	}

	PanelWindow {
		anchors { left: true; top: true; bottom: true; }
		width: 15;
		color: wal.adapter.colors.color0;
		HyprlandWindow.opacity: 0.8;
		WlrLayershell.namespace: "quickshell-border";
	}

	PanelWindow {
		anchors { right: true; top: true; bottom: true; }
		width: 15;
		color: wal.adapter.colors.color0;
		HyprlandWindow.opacity: 0.8;
		WlrLayershell.namespace: "quickshell-border";
	}

	PanelWindow {
			anchors { top: true; bottom: true; left: true; right: true }
			
			// CORRECT SYNTAX: Use dot notation for the grouped property
			surfaceFormat.opaque: false
			color: "transparent"
			HyprlandWindow.opacity: 0.8

			// 1. CLICK MASK: Handles mouse pass-through
			mask: Region {
					item: maskSource
					intersection: Intersection.Xor
			}

			// 2. RED FRAME (Hidden Source)
			Rectangle {
					id: redFrame
					anchors.fill: parent
					color: wal.adapter.colors.color0
					visible: false // Must be hidden so only the effect is seen
			}

			// 3. THE CUTOUT EFFECT
			MultiEffect {
					anchors.fill: parent
					source: redFrame
					maskSource: maskSource
					maskEnabled: true
					maskInverted: true // "Invert" to keep the outside, cut the inside
			}

			// 4. THE HOLE SHAPE (Mask)
			Rectangle {
					id: maskSource
					anchors.fill: parent
					anchors.margins: 5 // Border Thickness
					radius: 9         // Inner Radius
					color: "white"
					
					// CRITICAL FIXES FOR RED SCREEN:
					visible: false     
					layer.enabled: true // Forces this item to render to a texture even if hidden
					layer.smooth: true  // Ensures smooth rounded edges
			}


	}
}

