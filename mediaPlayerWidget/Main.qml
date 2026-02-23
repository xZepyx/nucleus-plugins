import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.config

Scope {
    id: globalRoot

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            color: "transparent"
            visible: Config.runtime.plugins.mediaPlayerWidget.enabled && Config.initialized
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData

            anchors { top: true; bottom: true; left: true; right: true }

            Item {
                id: rootContentContainer
                width: widget.implicitWidth
                height: widget.implicitHeight

                Component.onCompleted: {
                    x = Config.runtime.plugins.mediaPlayerWidget.xPos
                    y = Config.runtime.plugins.mediaPlayerWidget.yPos
                }

                MediaPlayerWidget {
                    id: widget
                    anchors.fill: parent
                }

                DragHandler {
                    target: rootContentContainer
                    acceptedButtons: Qt.RightButton
                    onActiveChanged: {
                        if (!active) {
                            Config.updateKey("plugins.mediaPlayerWidget.xPos", rootContentContainer.x)
                            Config.updateKey("plugins.mediaPlayerWidget.yPos", rootContentContainer.y)
                        }
                    }
                }
            }
        }
    }
}
