import QtQuick
import QtQuick.Layouts
import qs.plugins
import qs.modules.components

ColumnLayout {
    spacing: 15
    StyledText {
        text: "Media Player Widget - Plugin"
        font.pixelSize: 20
        font.bold: true
    }

    StyledSwitchOption {
        title: "Enabled"
        description: "Enable or disable the media player desktop widget plugin."
        prefField: "plugins.mediaPlayerWidget.enabled"
    }

    InfoCard {
        title: "Position"
        description: "Hold right click and drag your mouse to position the widget."
    }
}

