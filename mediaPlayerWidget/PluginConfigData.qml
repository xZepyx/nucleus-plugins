pragma Singleton
import QtQuick

QtObject {
    readonly property string pluginName: "mediaPlayerWidget"
    readonly property var defaults: ({
        enabled: true,
        xPos: 0,
        yPos: 0,
    })
}
