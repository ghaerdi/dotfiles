import Quickshell

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: panels.top;
			color: colors.background;

      ClockWidget {}
    }
  }
}
