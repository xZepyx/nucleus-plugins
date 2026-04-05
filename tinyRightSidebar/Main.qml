import QtQuick
import qs.services

Scope {
    Component.onCompleted: {
        if (Config.runtime.plugins.tinySidebarRight?.enabled !== true)
            return

        // 1. remove notifications
        PluginBus.hookSlot("sidebarRight", "notifModal", {
            mode: "remove"
        })

        // 2. override sidebar with inline wrapper
        ModuleRegistry.overrideModuleSource("sidebarRight", Qt.createComponent(`
            import QtQuick
            import qs.services

            Item {
                anchors.fill: parent

                Loader {
                    id: original
                    anchors.fill: parent

                    source: ModuleRegistry.modules.sidebarRight.source
                }

                Component.onCompleted: {
                    if (!original.item)
                        return

                    // shrink width
                    if (original.item.sidebarRightWidth !== undefined)
                        original.item.sidebarRightWidth = 420

                    // remove left margin / tighten layout
                    if (original.item.anchors)
                        original.item.anchors.leftMargin = 0
                }
            }
        `))
    }
}
