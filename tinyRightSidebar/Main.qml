import qs.config
import qs.modules.components
import qs.modules.functions
import qs.modules.interface.sidebarRight.content
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: sidebarRight
    WlrLayershell.namespace: "nucleus:sidebarRight"
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.initialized && Globals.visiblility.sidebarRight && !Globals.visiblility.sidebarLeft
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.keyboardFocus: Compositor.require("niri") && Globals.visiblility.sidebarRight
    
    property var monitor: Hyprland.focusedMonitor


    property real sidebarRightWidth: 470
    property real sidebarRightHeight: 490

    Component.onCompleted: {
		if (!Config.runtime.plugins.tinyRightSidebar.enabled)
                    return; 
		Contracts.overrideSidebarRight()
    }

    implicitWidth: sidebarRightWidth
    implicitHeight: sidebarRightHeight

    HyprlandFocusGrab {
        id: grab

        active: Compositor.require("hyprland")
        windows: [sidebarRight]
    }

    anchors {
        top: Config.runtime.bar.position === "top"
        right: (Config.runtime.bar.position === "top" || Config.runtime.bar.position === "bottom" || Config.runtime.bar.position === "right")
        bottom: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "bottom" || Config.runtime.bar.position === "right")
        left: (Config.runtime.bar.position === "left")
    }

    margins {
        top: Config.runtime.bar.margins
        bottom: Config.runtime.bar.margins
        left: Metrics.margin("small")
        right: Metrics.margin("small")
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    StyledRect {
        id: container
        color: Appearance.m3colors.m3background
        radius: Metrics.radius("large")
        implicitWidth: sidebarRight.sidebarRightWidth

        anchors.fill: parent

        FocusScope {
            focus: true 
            anchors.fill: parent
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    Globals.visiblility.sidebarRight = false;
                }
            }

            Item {
                anchors.fill: parent
                anchors.leftMargin: Metrics.margin("normal")
                anchors.rightMargin: Metrics.margin("normal")
                anchors.topMargin: Metrics.margin("large")
                anchors.bottomMargin: Metrics.margin("large")

                ColumnLayout {
                    id: mainLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: Metrics.margin("tiny")
                    anchors.rightMargin: Metrics.margin("tiny")
                    anchors.margins: Metrics.margin("large")
                    spacing: Metrics.margin("large")

                    RowLayout {
                        id: topSection
                        Layout.fillWidth: true

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.leftMargin: Metrics.margin(10)
                            Layout.alignment: Qt.AlignVCenter
                            spacing: Metrics.spacing(2)

                            RowLayout {
                                spacing: Metrics.spacing(8)

                                StyledText {
                                    text: SystemDetails.osIcon
                                    font.pixelSize: Metrics.fontSize("hugeass") + 6
                                }

                                StyledText {
                                    text: SystemDetails.uptime
                                    font.pixelSize: Metrics.fontSize("large")
                                    Layout.alignment: Qt.AlignBottom
                                    Layout.bottomMargin: Metrics.margin(5)
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Row {
                            spacing: Metrics.spacing(6)
                            Layout.leftMargin: Metrics.margin(25)
                            Layout.alignment: Qt.AlignVCenter

                            StyledRect {
                                id: screenshotbtncontainer
                                color: "transparent"
                                radius: Metrics.radius("large")
                                implicitHeight: screenshotButton.height + Metrics.margin("tiny")
                                implicitWidth: screenshotButton.width + Metrics.margin("small")
                                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                                Layout.topMargin: Metrics.margin(10)
                                Layout.leftMargin: Metrics.margin(15)

                                MaterialSymbolButton {
                                    id: screenshotButton
                                    icon: "edit"
                                    anchors.centerIn: parent
                                    iconSize: Metrics.iconSize("hugeass") + 2
                                    tooltipText: "Take a screenshot"

                                    onButtonClicked: {
                                        Quickshell.execDetached(["nucleus", "ipc", "call", "screen", "capture"])
                                        Globals.visiblility.sidebarRight = false;
                                    }
                                }
                            }

                            StyledRect {
                                id: reloadbtncontainer
                                color: "transparent"
                                radius: Metrics.radius("large")
                                implicitHeight: reloadButton.height + Metrics.margin("tiny")
                                implicitWidth: reloadButton.width + Metrics.margin("small")
                                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                                Layout.topMargin: Metrics.margin(10)
                                Layout.leftMargin: Metrics.margin(15)

                                MaterialSymbolButton {
                                    id: reloadButton
                                    icon: "refresh"
                                    anchors.centerIn: parent
                                    iconSize: Metrics.iconSize("hugeass") + 4
                                    tooltipText: "Reload Nucleus Shell"

                                    onButtonClicked: {
                                        Quickshell.execDetached(["nucleus", "run", "--reload"])
                                    }
                                }
                            }

                            StyledRect {
                                id: settingsbtncontainer
                                color: "transparent"
                                radius: Metrics.radius("large")
                                implicitHeight: settingsButton.height + Metrics.margin("tiny")
                                implicitWidth: settingsButton.width + Metrics.margin("small")
                                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                                Layout.topMargin: Metrics.margin(10)
                                Layout.leftMargin: Metrics.margin(15)

                                MaterialSymbolButton {
                                    id: settingsButton
                                    icon: "settings"
                                    anchors.centerIn: parent
                                    iconSize: Metrics.iconSize("hugeass") + 2
                                    tooltipText: "Open Settings"
                                    onButtonClicked: {
                                        Globals.visiblility.sidebarRight = false
                                        Globals.states.settingsOpen = true
                                    }
                                }
                            }

                            StyledRect {
                                id: powerbtncontainer
                                color: "transparent"
                                radius: Metrics.radius("large")
                                implicitHeight: settingsButton.height + Metrics.margin("tiny")
                                implicitWidth: settingsButton.width + Metrics.margin("small")
                                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                                Layout.topMargin: Metrics.margin(10)
                                Layout.leftMargin: Metrics.margin(15)

                                MaterialSymbolButton {
                                    id: powerButton
                                    icon: "power_settings_new"
                                    anchors.centerIn: parent
                                    iconSize: Metrics.iconSize("hugeass") + 2
                                    tooltipText: "Open PowerMenu"

                                    onButtonClicked: {
                                        Globals.visiblility.sidebarRight = false
                                        Globals.visiblility.powermenu = true
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Appearance.m3colors.m3outlineVariant
                        radius: Metrics.radius(1)
                    }

                    GridLayout {
                        id: middleGrid
                        Layout.fillWidth: true
                        columns: 1
                        columnSpacing: Metrics.spacing(8)
                        rowSpacing: Metrics.spacing(8)
                        Layout.preferredWidth: parent.width

                        RowLayout {
                            NetworkToggle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                            }
                            FlightModeToggle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 80
                            }
                        }

                        RowLayout {
                            BluetoothToggle {
                                Layout.preferredWidth: 220
                                Layout.preferredHeight: 80
                            }
                            ThemeToggle {
                                Layout.preferredHeight: 80
                                Layout.fillWidth: true
                            }
                            NightModeToggle {
                                Layout.preferredHeight: 80
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Appearance.m3colors.m3outlineVariant
                        radius: Metrics.radius(1)
                    }

                    ColumnLayout {
                        id: sliderColumn
                        Layout.fillWidth: true

                        VolumeSlider {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            icon: "volume_up"
                            iconSize: Metrics.iconSize("large") + 3
                        }

                        BrightnessSlider {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            icon: "brightness_high"
                        }
                    }

                    /* ColumnLayout {
                        spacing: Metrics.margin("small")
                        Layout.fillWidth: true

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: Appearance.m3colors.m3outlineVariant
                            radius: Metrics.radius(1)
                            Layout.topMargin: Metrics.margin(5)
                            Layout.bottomMargin: Metrics.margin(5)
                        }
                        
                        NotifModal {
                            Layout.preferredHeight: (Config.runtime.bar.position === "left" || Config.runtime.bar.position === "right") ? 480 : 470
                        }
                    } */
                }
            }

        }

    }

    // --- Toggle logic ---
    function togglesidebarRight() {
        Globals.visiblility.sidebarRight = !Globals.visiblility.sidebarRight
    }

    IpcHandler {
        target: "tinySidebarRight"
        function toggle() {
            togglesidebarRight()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            sidebarRight.monitor = Hyprland.focusedMonitor
        }
    }
}
