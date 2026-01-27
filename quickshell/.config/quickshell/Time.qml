pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.formatDateTime(clock.date, isDetailedFormat ? "dd MMMM yyyy" : "dddd hh:mm")
  }
	property bool isDetailedFormat: false

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
	}
}
