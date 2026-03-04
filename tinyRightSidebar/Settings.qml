import QtQuick
import QtQuick.Layouts
import qs.plugins
import qs.modules.components

ColumnLayout {
    spacing: 15
    StyledText {
        text: "Tiny Sidebar (Right Variant) - Plugin"
        font.pixelSize: 20
        font.bold: true
    }

    StyledSwitchOption {
        title: "Enabled"
        description: "Enable or disable the tiny sidebar plugin."
        prefField: "plugins.tinyRightSidebar.enabled"
    }
}
