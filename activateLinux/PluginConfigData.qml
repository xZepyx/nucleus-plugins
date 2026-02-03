pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    property string pluginName: "activateLinux"

    property var defaults: ({
        property bool enabled: true
    })
}

