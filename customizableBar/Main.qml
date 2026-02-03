import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services
import qs.modules.components
import qs.modules.interface.bar
import qs.modules.interface.bar.content
import QtQuick.Layouts

Scope {
    id: root

    GothCorners {
       opacity: Config.runtime.bar.gothCorners && !Config.runtime.bar.floating && Config.runtime.plugins.customizableBar.enabled && !Config.runtime.bar.merged ? 1 : 0
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            // some exclusiveSpacing so it won't look like its sticking into the window when floating

            id: bar

            Component.onCompleted: {
                Contracts.overrideBar()
            }

            required property var modelData
            property int rd: Config.runtime.bar.radius * Config.runtime.appearance.rounding.factor // So it won't be modified when factor is 0
            property int margin: Config.runtime.bar.margins
            property bool floating: Config.runtime.bar.floating
            property bool merged: Config.runtime.bar.merged
            property string pos: Config.runtime.bar.position
            property bool vertical: pos === "left" || pos === "right"
            // Simple position properties
            property bool attachedTop: pos === "top"
            property bool attachedBottom: pos === "bottom"
            property bool attachedLeft: pos === "left"
            property bool attachedRight: pos === "right"

            screen: modelData // Show bar on all screens
            visible: Config.runtime.plugins.customizableBar.enabled && Config.initialized
            WlrLayershell.namespace: "nucleus:bar"
            implicitHeight: Config.runtime.bar.density //Config.runtime.bar.density // density === height. (horizontal orientation)
            implicitWidth: Config.runtime.bar.density // density === width. (vertical orientation)
            color: "transparent" // Keep panel window's color transparent, so that it can be modified by background rect

            // Only supports horizontal Layout rn
            anchors {
                top: Config.runtime.bar.position === "top"
                bottom: Config.runtime.bar.position === "bottom"
                left: true
                right: true
            }

            margins {
                top: {
                    if (floating)
                        return margin;

                    if (merged && vertical)
                        return margin;

                    return 0;
                }
                bottom: {
                    if (floating)
                        return margin;

                    if (merged && vertical)
                        return margin;

                    return 0;
                }
                left: {
                    if (floating)
                        return margin;

                    if (merged && !vertical)
                        return margin;

                    return 0;
                }
                right: {
                    if (floating)
                        return margin;

                    if (merged && !vertical)
                        return margin;

                    return 0;
                }
            }

            StyledRect {
                id: background

                color: Appearance.m3colors.m3background
                anchors.fill: parent
                topLeftRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedBottom || attachedRight ? rd : 0;
                }
                topRightRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedBottom || attachedLeft ? rd : 0;
                }
                bottomLeftRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedTop || attachedRight ? rd : 0;
                }
                bottomRightRadius: {
                    if (floating)
                        return rd;

                    if (!merged)
                        return 0;

                    return attachedTop || attachedLeft ? rd : 0;
                }


                Item {
                    anchors.fill: parent
                    id: content

                    StyledRect {
                        id: bg

                        color: Appearance.m3colors.m3background
                        anchors.fill: parent
                        topLeftRadius: {
                            if (floating)
                                return rd;

                            if (!merged)
                                return 0;

                            return attachedBottom || attachedRight ? rd : 0;
                        }
                        topRightRadius: {
                            if (floating)
                                return rd;

                            if (!merged)
                                return 0;

                            return attachedBottom || attachedLeft ? rd : 0;
                        }
                        bottomLeftRadius: {
                            if (floating)
                                return rd;

                            if (!merged)
                                return 0;

                            return attachedTop || attachedRight ? rd : 0;
                        }
                        bottomRightRadius: {
                            if (floating)
                                return rd;

                            if (!merged)
                                return 0;

                            return attachedTop || attachedLeft ? rd : 0;
                        }

                        Behavior on bottomLeftRadius {
                            enabled: Config.runtime.appearance.animations.enabled
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                        }

                        Behavior on topLeftRadius {
                            enabled: Config.runtime.appearance.animations.enabled
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                        }

                        Behavior on bottomRightRadius {
                            enabled: Config.runtime.appearance.animations.enabled
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                        }

                        Behavior on topRightRadius {
                            enabled: Config.runtime.appearance.animations.enabled
                            animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                        }
                    }

                    Row {
                        id: leftRow
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4
                    }

                    Row {
                        id: centerRow
                        anchors.centerIn: parent
                        spacing: 4
                    }

                    RowLayout {
                        id: rightRow
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4
                    }


                    // Chose Row Based on Module Pos

                    function rowFor(pos) {
                        if (pos === "left")   return leftRow
                        if (pos === "center") return centerRow
                        return rightRow
                    }

                    WorkspaceModule {
                        id: mWorkspaces
                        visible: Config.runtime.plugins.customizableBar.modules.workspaces.enabled
                        Binding {
                            target: mWorkspaces
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.workspaces.position)
                        }
                    }

                    BongoCat {
                        id: mBongoCat
                        visible: Config.runtime.plugins.customizableBar.modules.bongoCat.enabled
                        Binding {
                            target: mBongoCat
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.bongoCat.position)
                        }
                    }

                    SystemUsageModule {
                        id: mSystemUsageModule
                        visible: Config.runtime.plugins.customizableBar.modules.systemUsage.enabled
                        Binding {
                            target: mSystemUsageModule
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.systemUsage.position)
                        }                        
                    }

                    MediaPlayerModule {
                        id: mMedia
                        visible: Config.runtime.plugins.customizableBar.modules.media.enabled
                        Binding {
                            target: mMedia
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.media.position)
                        }
                    }

                    StatusIconsModule {
                        id: mStatusIcons
                        visible: Config.runtime.plugins.customizableBar.modules.statusIcons.enabled
                        Binding {
                            target: mStatusIcons
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.statusIcons.position)
                        }
                    }

                    ActiveWindowModule {
                        id: mActiveTopLevel
                        visible: Config.runtime.plugins.customizableBar.modules.activeTopLevel.enabled
                        Binding {
                            target: mActiveTopLevel
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.activeTopLevel.position)
                        }
                    }

                    ClockModule {
                        id: mClock
                        visible: Config.runtime.plugins.customizableBar.modules.clock.enabled
                        Binding {
                            target: mClock
                            property: "parent"
                            value: content.rowFor(Config.runtime.plugins.customizableBar.modules.clock.position)
                        }
                    }


                }


                Behavior on bottomLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topLeftRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on bottomRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

                Behavior on topRightRadius {
                    enabled: Config.runtime.appearance.animations.enabled
                    animation: Appearance.animation.elementMove.numberAnimation.createObject(this)
                }

            }

        }

    }

}
