pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    readonly property string pluginName: "activateLinux"

    readonly property JsonObject defaults: JsonObject {
        property bool enabled: true
    }
}

