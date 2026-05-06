import Quickshell
import QtQuick

Scope {
  id: root

  property bool trayExpanded: false

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

      // Left section
      Item {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: panels.top
        width: leftRow.implicitWidth + 30

        Rectangle {
          anchors.fill: parent
          color: colors.background
          radius: styles.radius

          // Mask top-left, top-right, bottom-left for CSS border-radius: 0 0 15px 0
          Rectangle { width: parent.radius; height: parent.radius; anchors.top: parent.top; anchors.left: parent.left; color: parent.color }
          Rectangle { width: parent.radius; height: parent.radius; anchors.top: parent.top; anchors.right: parent.right; color: parent.color }
          Rectangle { width: parent.radius; height: parent.radius; anchors.bottom: parent.bottom; anchors.left: parent.left; color: parent.color }
        }

        Row {
          id: leftRow
          anchors.verticalCenter: parent.verticalCenter
          x: 15
          spacing: 0

          WindowsCountWidget {
            anchors.verticalCenter: parent.verticalCenter
          }

          WorkspacesWidget {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 10
            rightPadding: 10
          }

          LoveWidget {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 10
            rightPadding: 10
          }
        }
      }

      // Center section
      ClockWidget {
        anchors.centerIn: parent
      }

      // Right section
      Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        // Tray expander group - expands on hover
        Item {
          height: panels.top
          width: trayRow.implicitWidth

            MouseArea {
              anchors.fill: parent
              hoverEnabled: true
              acceptedButtons: Qt.NoButton
              cursorShape: Qt.PointingHandCursor
              onEntered: root.trayExpanded = true
              onExited: root.trayExpanded = false
            }

          Row {
            id: trayRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            ExpandIconWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
            }

            TrayWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
              visible: root.trayExpanded
            }

            BluetoothWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
              visible: root.trayExpanded
            }

            PulseaudioWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
              visible: root.trayExpanded
            }

            CpuWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
              visible: root.trayExpanded
            }

            DiskWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
              visible: root.trayExpanded
            }
          }
        }

        // System group
        Item {
          height: panels.top
          width: systemRow.implicitWidth + 30

          Rectangle {
            anchors.fill: parent
            color: colors.background
            radius: styles.radius

            // Mask top-left, top-right, bottom-right for CSS border-radius: 0 0 0 15px
            Rectangle { width: parent.radius; height: parent.radius; anchors.top: parent.top; anchors.left: parent.left; color: parent.color }
            Rectangle { width: parent.radius; height: parent.radius; anchors.top: parent.top; anchors.right: parent.right; color: parent.color }
            Rectangle { width: parent.radius; height: parent.radius; anchors.bottom: parent.bottom; anchors.right: parent.right; color: parent.color }
          }

          Row {
            id: systemRow
            anchors.verticalCenter: parent.verticalCenter
            x: 15
            spacing: 0

            NetworkWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
            }

            BatteryWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
            }

            NotificationCenterWidget {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              rightPadding: 10
            }
          }
        }
      }
    }
  }
}
