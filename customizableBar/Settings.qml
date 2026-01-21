import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.widgets
import qs.services

ColumnLayout {
    StyledText {
        text: "Customizable Bar - Plugin"
        font.bold: true 
        font.pixelSize: 20
    }
    StyledSwitchOption {
        title: "Enabled"
        description: "Enable or disable the customizable Bar"
        prefField: "plugins.customizableBar.enabled"
    }

    StyledText {
        text: "Bar Content"
        font.pixelSize: 20
        font.bold: true
    }

    ColumnLayout {
        // --- Workspaces ---
        ColumnLayout {
            StyledText {
                text: "Workspaces"
                font.pixelSize: 16
                font.bold: true
            }

            StyledSwitchOption {
                title: "Enabled"
                description: "Enable Workspaces"
                prefField: "plugins.customizableBar.modules.workspaces.enabled"

                RowLayout {
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: Appearance.m3colors.m3outline
                    }

                    Repeater {
                        model: ['Left', 'Center', 'Right']

                        delegate: StyledButton {
                            property string posValue: modelData.toLowerCase()

                            text: modelData
                            implicitWidth: 80
                            checked: Config.runtime.plugins.customizableBar.modules.workspaces.position === posValue
                            topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            onClicked: Config.updateKey("plugins.customizableBar.modules.workspaces.position", posValue)
                        }

                    }

                }

            }

        }

        // --- System Usage ---
        ColumnLayout {
            StyledText {
                text: "System Usage"
                font.pixelSize: 16
                font.bold: true
            }

            StyledSwitchOption {
                title: "Enabled"
                description: "Enable System Usage Module"
                prefField: "plugins.customizableBar.modules.systemUsage.enabled"

                RowLayout {
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: Appearance.m3colors.m3outline
                    }

                    Repeater {
                        model: ['Left', 'Center', 'Right']

                        delegate: StyledButton {
                            property string posValue: modelData.toLowerCase()

                            text: modelData
                            implicitWidth: 80
                            checked: Config.runtime.plugins.customizableBar.modules.systemUsage.position === posValue
                            topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            onClicked: Config.updateKey("plugins.customizableBar.modules.systemUsage.position", posValue)
                        }

                    }

                }

            }

        }

        // --- Bongo Cat ---
        ColumnLayout {
            StyledText {
                text: "Bongo Cat"
                font.pixelSize: 16
                font.bold: true
            }

            StyledSwitchOption {
                title: "Enabled"
                description: "Enable Bongo Cat Module"
                prefField: "plugins.customizableBar.modules.bongoCat.enabled"

                RowLayout {
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: Appearance.m3colors.m3outline
                    }

                    Repeater {
                        model: ['Left', 'Center', 'Right']

                        delegate: StyledButton {
                            property string posValue: modelData.toLowerCase()

                            text: modelData
                            implicitWidth: 80
                            checked: Config.runtime.plugins.customizableBar.modules.bongoCat.position === posValue
                            topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            onClicked: Config.updateKey("plugins.customizableBar.modules.bongoCat.position", posValue)
                        }

                    }

                }

            }

        }

        // --- Media ---
        ColumnLayout {
            StyledText {
                text: "Media"
                font.pixelSize: 16
                font.bold: true
            }

            StyledSwitchOption {
                title: "Enabled"
                description: "Enable Media Module"
                prefField: "plugins.customizableBar.modules.media.enabled"

                RowLayout {
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: Appearance.m3colors.m3outline
                    }

                    Repeater {
                        model: ['Left', 'Center', 'Right']

                        delegate: StyledButton {
                            property string posValue: modelData.toLowerCase()

                            text: modelData
                            implicitWidth: 80
                            checked: Config.runtime.plugins.customizableBar.modules.media.position === posValue
                            topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            onClicked: Config.updateKey("plugins.customizableBar.modules.media.position", posValue)
                        }

                    }

                }

            }

        }

        // --- Status Icons ---
        ColumnLayout {
            StyledText {
                text: "Status Icons"
                font.pixelSize: 16
                font.bold: true
            }

            StyledSwitchOption {
                title: "Enabled"
                description: "Enable Status Icons Module"
                prefField: "plugins.customizableBar.modules.statusIcons.enabled"

                RowLayout {
                    Rectangle {
                        width: 1
                        Layout.fillHeight: true
                        color: Appearance.m3colors.m3outline
                    }

                    Repeater {
                        model: ['Left', 'Center', 'Right']

                        delegate: StyledButton {
                            property string posValue: modelData.toLowerCase()

                            text: modelData
                            implicitWidth: 80
                            checked: Config.runtime.plugins.customizableBar.modules.statusIcons.position === posValue
                            topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                            onClicked: Config.updateKey("plugins.customizableBar.modules.statusIcons.position", posValue)
                        }

                    }

                }

            }

            // --- Active Window ---
            ColumnLayout {
                StyledText {
                    text: "Active Window"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Active Top Level Module"
                    prefField: "plugins.customizableBar.modules.activeTopLevel.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Config.runtime.plugins.customizableBar.modules.activeTopLevel.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Config.updateKey("plugins.customizableBar.modules.activeTopLevel.position", posValue)
                            }

                        }

                    }

                }

                // --- Clock ---
                ColumnLayout {
                    StyledText {
                        text: "Clock"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    StyledSwitchOption {
                        title: "Enabled"
                        description: "Enable Clock Module"
                        prefField: "plugins.customizableBar.modules.clock.enabled"

                        RowLayout {
                            Rectangle {
                                width: 1
                                Layout.fillHeight: true
                                color: Appearance.m3colors.m3outline
                            }

                            Repeater {
                                model: ['Left', 'Center', 'Right']

                                delegate: StyledButton {
                                    property string posValue: modelData.toLowerCase()

                                    text: modelData
                                    implicitWidth: 80
                                    checked: Config.runtime.plugins.customizableBar.modules.clock.position === posValue
                                    topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                    bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                    topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                    bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                    onClicked: Config.updateKey("plugins.customizableBar.modules.clock.position", posValue)
                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
