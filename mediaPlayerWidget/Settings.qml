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

    StyledSwitchOption {
        title: "Custom Dimensions"
        description: "Modify the width and height of the widget."
        prefField: "plugins.mediaPlayerWidget.useCustomDimensions"
    }

    NumberStepper {
        label: "Width"
        description: "Adjust the width of the widget."
        prefField: "plugins.mediaPlayerWidget.width"
        minimum: 350
        maximum: 600
        opacity: Config.runtime.plugins.mediaPlayerWidget.useCustomDimensions ? 1 : 0.8
        active: Config.runtime.plugins.mediaPlayerWidget.useCustomDimensions
    }

    NumberStepper {
        label: "Height"
        description: "Adjust the height of the widget."
        prefField: "plugins.mediaPlayerWidget.height"
        minimum: 300
        maximum: 600
        opacity: Config.runtime.plugins.mediaPlayerWidget.useCustomDimensions ? 1 : 0.8
        active: Config.runtime.plugins.mediaPlayerWidget.useCustomDimensions
    }

    InfoCard {
        title: "Position"
        description: "Hold right click and drag your mouse to position the widget."
    }
}

