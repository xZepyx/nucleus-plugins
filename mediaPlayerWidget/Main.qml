import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.config
import qs.modules.interface.sidebarRight.content
import qs.modules.components
import qs.services

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clock

            required property var modelData
            property int padding: 50

            color: "transparent"
            visible: (Config.runtime.plugins.mediaPlayerWidget.enabled && Config.initialized)
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Bottom
            screen: modelData

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                top: padding
                bottom: padding
                left: padding
                right: padding
            }

            Item {
                id: rootContentContainer

                height: 200
                width: 400
                Component.onCompleted: {
                    x = Config.runtime.plugins.mediaPlayerWidget.xPos;
                    y = Config.runtime.plugins.mediaPlayerWidget.yPos;
                }

                StyledRect {
                    anchors.fill: parent
                    color: Appearance.m3colors.m3background
                    radius: Appearance.rounding.normal

                    StyledRect {
                        id: root

                        anchors.fill: parent
                        radius: Appearance.rounding.normal
                        color: Appearance.m3colors.m3surfaceContainer

                        ClippingRectangle {
                            color: Appearance.colors.colLayer1
                            radius: Appearance.rounding.normal
                            implicitHeight: 90
                            anchors.fill: parent

                            RowLayout {
                                anchors.fill: parent
                                spacing: Appearance.margin.small

                                // Artwork
                                ClippingRectangle {
                                    implicitWidth: 140
                                    implicitHeight: 140
                                    Layout.leftMargin: Appearance.margin.large
                                    radius: Appearance.rounding.normal
                                    clip: true
                                    color: Appearance.colors.colLayer2

                                    Image {
                                        anchors.fill: parent
                                        source: Mpris.artUrl
                                        fillMode: Image.PreserveAspectCrop
                                        cache: true
                                    }

                                    MaterialSymbol {
                                        icon: "music_note"
                                        iconSize: 82
                                        anchors.centerIn: parent
                                        fill: 1
                                        visible: Mpris.artUrl === ""
                                    }

                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.rightMargin: Appearance.margin.small
                                    spacing: 2

                                    // Title
                                    Text {
                                        text: Mpris.title
                                        elide: Text.ElideRight
                                        Layout.maximumWidth: 190
                                        font.family: Appearance.font.family.title
                                        font.pixelSize: Appearance.font.size.hugeass
                                        font.bold: true
                                        color: Appearance.colors.colOnLayer2
                                    }

                                    // Artist
                                    Text {
                                        text: Mpris.artist
                                        elide: Text.ElideRight
                                        Layout.maximumWidth: 160
                                        font.family: Appearance.font.family.main
                                        font.pixelSize: Appearance.font.size.normal
                                        color: Appearance.colors.colSubtext
                                    }

                                    // Controls
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 12

                                        Button {
                                            Layout.preferredWidth: 36
                                            Layout.preferredHeight: 36
                                            onClicked: Mpris.previous()

                                            background: Rectangle {
                                                radius: Appearance.rounding.large
                                                color: Appearance.colors.colLayer2
                                            }

                                            contentItem: MaterialSymbol {
                                                anchors.centerIn: parent
                                                icon: "skip_previous"
                                                font.pixelSize: 24
                                                color: Appearance.colors.colOnLayer2
                                                fill: 1
                                            }

                                        }

                                        StyledButton {
                                            Layout.preferredWidth: 42
                                            Layout.preferredHeight: 42
                                            onClicked: Mpris.playPause()
                                            icon: Mpris.isPlaying ? "pause" : "play_arrow"
                                            iconSize: 28
                                        }

                                        Button {
                                            Layout.preferredWidth: 36
                                            Layout.preferredHeight: 36
                                            onClicked: Mpris.next()

                                            background: Rectangle {
                                                radius: Appearance.rounding.large
                                                color: Appearance.colors.colLayer2
                                            }

                                            contentItem: MaterialSymbol {
                                                anchors.centerIn: parent
                                                icon: "skip_next"
                                                font.pixelSize: 24
                                                color: Appearance.colors.colOnLayer2
                                                fill: 1
                                            }

                                        }

                                    }

                                    // Timeline
                                    RowLayout {
                                        Layout.topMargin: 15
                                        Layout.fillWidth: true
                                        spacing: 12

                                        Item {
                                            Layout.fillWidth: true
                                            implicitHeight: 20

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: Appearance.rounding.full
                                                color: Appearance.colors.colLayer2
                                            }

                                            Rectangle {
                                                width: parent.width * (Mpris.length > 0 ? Mpris.position / Mpris.length : 0)
                                                radius: Appearance.rounding.full
                                                color: Appearance.colors.colPrimary

                                                anchors {
                                                    left: parent.left
                                                    top: parent.top
                                                    bottom: parent.bottom
                                                }

                                            }

                                        }

                                    }

                                }

                            }

                        }

                    }

                }

                MouseArea {
                    id: ma

                    anchors.fill: parent
                    drag.target: rootContentContainer
                    acceptedButtons: Qt.RightButton
                    drag.axis: Drag.XAndYAxis
                    onReleased: {
                        if (mouse.button !== Qt.RightButton)
                            return ;

                        Config.updateKey("plugins.mediaPlayerWidget.xPos", rootContentContainer.x);
                        Config.updateKey("plugins.mediaPlayerWidget.yPos", rootContentContainer.y);
                    }
                }

            }

        }

    }

}
