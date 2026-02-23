import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.modules.components

Item {
    id: root

    ColorQuantizer {
    id: colorQuantizer
    source: root.player?.trackArtUrl ? root.player.trackArtUrl : undefined
    depth: 2
    rescaleSize: 64
}

    // Adaptive Theme properties
    property color dynamicBg: colorQuantizer.colors.length > 0 ? colorQuantizer.colors[0] : "#1e1e2e"
    property color dynamicAccent: colorQuantizer.colors.length > 0 ? colorQuantizer.colors[0] : "#89b4fa"
    property bool isLight: Qt.color(dynamicBg).hslLightness > 0.6

    property color backgroundColor: dynamicBg
    property color foregroundColor: isLight ? "#11111b" : "#ffffffff"
    property color mutedColor: isLight ? "#45475a" : "#ffffffff"
    property color secondaryColor: isLight ? "#313244" : "#ffffffff"
    property color accentColor: dynamicAccent
    property color surfaceColor: isLight ? Qt.darker(dynamicBg, 1.1) : Qt.lighter(dynamicBg, 1.3)
    property color hoverColor: isLight ? Qt.darker(dynamicBg, 1.2) : Qt.lighter(dynamicBg, 1.5)
    property color badgeColor: dynamicBg
    property color badgeBorder: isLight ? Qt.darker(dynamicBg, 1.4) : Qt.lighter(dynamicBg, 1.7)
    property color volumeColor: dynamicAccent

    property int cornerRadius: 20
    property int albumArtSize: 110
    property bool showProgressBar: true
    property bool showPlayerDots: true

    Behavior on backgroundColor { ColorAnimation { duration: 500 } }
    Behavior on foregroundColor { ColorAnimation { duration: 500 } }
    Behavior on mutedColor { ColorAnimation { duration: 500 } }
    Behavior on secondaryColor { ColorAnimation { duration: 500 } }
    Behavior on accentColor { ColorAnimation { duration: 500 } }
    Behavior on surfaceColor { ColorAnimation { duration: 500 } }

    property int playerIndex: 0
    property MprisPlayer player: Mpris.players.values.length > 0 ? Mpris.players.values[playerIndex % Mpris.players.values.length] : null

    implicitWidth: Math.max(450, playerContent.implicitWidth + 40)
    implicitHeight: slideContainer.height + bottomSection.height + 30

    function cyclePlayer(direction) {
        const count = Mpris.players.values.length
        if (count === 0) return
        playerIndex = (playerIndex + direction + count) % count
        slideAnim.stop()
        playerContent.x = direction * (slideContainer.width + 12)
        slideAnim.to = 0
        slideAnim.start()
    }

    function formatTime(seconds) {
        const s = Math.floor(seconds)
        const m = Math.floor(s / 60)
        const h = Math.floor(m / 60)
        if (h > 0) return h + ":" + String(m % 60).padStart(2, "0") + ":" + String(s % 60).padStart(2, "0")
        return m + ":" + String(s % 60).padStart(2, "0")
    }

    Timer { running: root.player?.playbackState === MprisPlaybackState.Playing; interval: 1000; repeat: true; onTriggered: root.player?.positionChanged() }

    Connections { target: Mpris.players; function onValuesChanged() { root.playerIndex = Mpris.players.values.length === 0 ? 0 : root.playerIndex % Mpris.players.values.length } }

    // Background card
    Item {
        anchors.fill: parent

        // Outer drop shadow
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#88000000"
            shadowBlur: 0.9
            shadowVerticalOffset: 4
            shadowHorizontalOffset: 2
            autoPaddingEnabled: true
        }

        ClippingRectangle {
            anchors.fill: parent
            radius: root.cornerRadius
            color: root.backgroundColor
            clip: true

            Image {
                id: bgArtImage
                // Extend anchors so the blur doesn't have hard edges inside the box
                anchors { fill: parent; margins: -32 }
                source: root.player?.trackArtUrl || undefined
                fillMode: Image.PreserveAspectCrop
                opacity: 0.8
                asynchronous: true

                layer.enabled: true
                layer.effect: MultiEffect {
                    blurEnabled: true
                    blurMax: 64
                    blur: 1.0
                    saturation: 1.2
                }
            }

            // Contrast overlay
            Rectangle {
                anchors.fill: parent
                color: root.backgroundColor
                opacity: 0.65
            }
            
            // Border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: root.surfaceColor
                border.width: 1
                radius: root.cornerRadius
            }
        }
    }

    // Slide container
    Item {
        id: slideContainer
        clip: true
        anchors { top: parent.top; left: parent.left; right: parent.right; topMargin: 12 }
        height: playerContent.implicitHeight

        SpringAnimation { id: slideAnim; target: playerContent; property: "x"; spring: 4.5; damping: 0.35; mass: 1.0 }

        PlayerContent {
            id: playerContent
            x: 0
            width: slideContainer.width
            player: root.player
        }
    }

    // Cycle arrows
    CycleArrow {
        anchors { left: parent.left; verticalCenter: slideContainer.verticalCenter; leftMargin: -12 }
        arrowText: "‹"
        visible: Mpris.players.values.length > 1
        onClicked: (mouse) => root.cyclePlayer(-1)
    }

    CycleArrow {
        anchors { right: parent.right; verticalCenter: slideContainer.verticalCenter; rightMargin: -12 }
        arrowText: "›"
        visible: Mpris.players.values.length > 1
        onClicked: (mouse) => root.cyclePlayer(1)
    }

    // Progress bar + player dots
    Column {
        id: bottomSection
        spacing: 6
        anchors { top: slideContainer.bottom; left: parent.left; right: parent.right; topMargin: 6; leftMargin: 12; rightMargin: 12 }

        ProgressBar { width: parent.width; visible: root.showProgressBar && root.player !== null }
        PlayerDots { width: parent.width; visible: root.showPlayerDots && Mpris.players.values.length > 1 }
    }

    // ── Inline components ────────────────────────────────────────────────────

    component CycleArrow: Rectangle {
        property string arrowText
        signal clicked(var mouse)

        width: 20
        height: slideContainer.height
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: parent.arrowText
            color: arrowMa.containsMouse ? root.foregroundColor : root.hoverColor
            font.pixelSize: 16
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea { 
            id: arrowMa
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse) => parent.clicked(mouse) 
        }
    }

    component ProgressBar: RowLayout {
        spacing: 6

        Text {
            text: root.formatTime(root.player?.position ?? 0)
            color: root.mutedColor
            font.pixelSize: 10
        }

        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: root.surfaceColor

            Rectangle {
                width: root.player?.length > 0
                    ? parent.width * (Math.min(root.player.position, root.player.length) / root.player.length)
                    : 0
                height: parent.height
                radius: parent.radius
                color: "white"
                Behavior on width { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0 } }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => { if (root.player?.canSeek) root.player.position = root.player.length * (mouse.x / width) }
            }
        }

        Text {
            text: root.formatTime(root.player?.length ?? 0)
            color: root.mutedColor
            font.pixelSize: 10
        }
    }

    component PlayerDots: Item {
        height: 6
        Row {
            anchors.centerIn: parent
            spacing: 6
            Repeater {
                model: Mpris.players.values.length
                delegate: Rectangle {
                    width: index === root.playerIndex ? 16 : 6
                    height: 6
                    radius: 3
                    color: index === root.playerIndex ? "white" : root.hoverColor
                    Behavior on width { SpringAnimation { spring: 4.5; damping: 0.35; mass: 1.0 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                    MouseArea { anchors.fill: parent; acceptedButtons: Qt.LeftButton | Qt.RightButton; onClicked: { if (index !== root.playerIndex) root.cyclePlayer(index > root.playerIndex ? 1 : -1) } }
                }
            }
        }
    }

    component PlayerContent: Item {
        property MprisPlayer player
        implicitHeight: contentCol.implicitHeight

        property var entry: null
        property string iconSource: ""

        onPlayerChanged: updateEntry()
        Component.onCompleted: updateEntry()

        Connections { target: player; function onDesktopEntryChanged() { updateEntry() } }

        function updateEntry() {
            if (!player?.desktopEntry) { entry = null; iconSource = ""; return }
            entry = DesktopEntries.heuristicLookup(player.desktopEntry)
            iconSource = entry?.icon ? Quickshell.iconPath(entry.icon, true) : undefined
        }

        Timer { interval: 200; repeat: true; running: iconSource === "" && player?.desktopEntry !== undefined; onTriggered: { updateEntry(); running = false } }

        ColumnLayout {
            id: contentCol
            anchors { left: parent.left; right: parent.right; leftMargin: 8; rightMargin: 8 }
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                AlbumArt { Layout.alignment: Qt.AlignVCenter; player: contentCol.parent.player; iconSource: contentCol.parent.iconSource }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 200
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: player?.trackTitle ?? "Nothing playing"
                        color: root.foregroundColor
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: player?.trackArtist ?? ""
                        color: root.secondaryColor
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        visible: text !== ""
                    }

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true
                        property bool isPlaying: player?.playbackState === MprisPlaybackState.Playing

                        MediaButton { Layout.alignment: Qt.AlignVCenter; btnIcon: "skip_previous"; enabled: player?.canGoPrevious ?? false; onClicked: player?.previous() }
                        MediaButton { Layout.alignment: Qt.AlignVCenter; btnIcon: parent.isPlaying ? "pause" : "play_arrow"; enabled: player?.canTogglePlaying ?? false; onClicked: player?.togglePlaying() }
                        MediaButton { Layout.alignment: Qt.AlignVCenter; btnIcon: "skip_next"; enabled: player?.canGoNext ?? false; onClicked: player?.next() }
                        Item { Layout.fillWidth: true } // spacer
                    }
                }
            }
        }
    }

    component AlbumArt: Item {
        property MprisPlayer player
        property string iconSource

        width: root.albumArtSize
        height: root.albumArtSize

        Item {
            id: artItem
            width: root.albumArtSize
            height: root.albumArtSize

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#aa000000"
                shadowBlur: 0.8
                shadowVerticalOffset: 3
                shadowHorizontalOffset: 2
                autoPaddingEnabled: true
            }

            ClippingRectangle {
                anchors.fill: parent
                radius: root.cornerRadius
                color: root.surfaceColor
                clip: true

                Image {
                    id: artImage
                    anchors.fill: parent
                    source: player?.trackArtUrl || ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }

                MaterialSymbol {
                    anchors.centerIn: parent
                    icon: "music_note"
                    iconSize: 32
                    color: root.foregroundColor
                    visible: artImage.source.toString() === ""
                }
            }
        }

        Rectangle {
            visible: iconSource !== ""
            anchors { right: artItem.right; bottom: artItem.bottom; rightMargin: -4; bottomMargin: -4 }
            width: 22
            height: 22
            radius: 7
            color: badgeMa.containsMouse && player?.canRaise ? root.surfaceColor : root.badgeColor
            border.color: root.badgeBorder
            border.width: 1
            Behavior on color { ColorAnimation { duration: 150 } }

            Image {
                anchors { fill: parent; margins: 3 }
                source: iconSource
                fillMode: Image.PreserveAspectFit
                smooth: true
                opacity: badgeMa.containsMouse && player?.canRaise ? 1.0 : 0.7
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }

            MouseArea {
                id: badgeMa
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                enabled: player?.canRaise ?? false
                cursorShape: player?.canRaise ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: player?.raise()
            }
        }
    }

    // VolumeControl removed as requested

    component MediaButton: Rectangle {
        property string btnIcon
        property bool enabled: true
        signal clicked()

        width: 32
        height: 32
        radius: 6
        color: btnMa.containsMouse ? root.hoverColor : "transparent"

        MaterialSymbol {
            anchors.centerIn: parent
            icon: parent.btnIcon
            color: parent.enabled ? root.foregroundColor : root.mutedColor
            iconSize: 24
        }

        MouseArea { id: btnMa; anchors.fill: parent; hoverEnabled: true; enabled: parent.enabled; acceptedButtons: Qt.LeftButton | Qt.RightButton; onClicked: parent.clicked() }
    }
}
