pragma Singleton
import QtQuick
import qs.config

QtObject {
    readonly property string pluginName: "customizableBar"

    readonly property var defaults: ({
        enabled: true,
        modules: {
            statusIcons: {
                enabled: true,
                position: "right",
            },

            media: {
                enabled: true,
                position: "center",
            },

            systemUsage: {
                enabled: true,
                position: "center",
            },

            activeTopLevel: {
                enabled: true,
                position: "center",
            },

            clock: {
                enabled: true,
                position: "right",
            },

            bongoCat: {
                enabled: true,
                position: "right",
            },

            workspaces: {
                enabled: true,
                position: "left",
            }
        }
    })
}
