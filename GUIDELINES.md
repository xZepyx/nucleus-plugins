# Plugin Documentation

This document will explain how to create your own plugin.

## Plugin Structure
* All the plugins are stored/installed at `~/.config/nucleus-shell/plugins`
* Each plugin should consist of these five files: `Main.qml`, `PluginConfigData.qml`, `Settings.qml`, `preview.png/jpg/jpeg` and `manifest.json`
* If any of these files are not present the plugin will not work or break.

## File Data
**`Main.qml`**: This is the root file of the plugin all the files and other stuff should be iniatated in this file. You can also have other files and folders under a plugin.

**`Settings.qml`**: This is the file which has all the customizable options (for the settings app). Example File:
```qml
import QtQuick
import QtQuick.Layouts
import qs.plugins
import qs.modules.widgets

ColumnLayout {
    spacing: 15
    StyledText {
        text: "Example - Plugin"
        font.pixelSize: 20
        font.bold: true
    }

    StyledSwitchOption {
        title: "Enabled"
        description: "Enable or disable the Example Plugin."
        prefField: "plugins.example.enabled" // here "example" is the plugin id.
    }
}
```

* Note that the pluginId should be the folderName of the plugin under `~/.config/nucleus-shell/plugins/<pluginName>`
* Example: If the plugin folderName is `~/.config/nucleus-shell/plugins/examplePlugin` the id should also be examplePlugin everywhere else inOrder for it to work.

**`PluginConfigData.qml`**: This file stores all the configuration options for the plugin. Example File:
```qml
pragma Singleton
import QtQuick

QtObject {
    readonly property string pluginName: "example" // Should be present at all times.
    readonly property var defaults: ({ // All the properties should be stored here. Anything outside of it will not be recognized by the shell.
        enabled: true
    })
}
```

* Note that the properties should be accessed like this: `Config.runtime.plugins.pluginId.property` under all the plugin files not as `PluginConfigData.defaults.enabled` (this will not work because it is only a placeholder not the actual stored json file which gets edited)

**`manifest.json`**: This file stores all the additional information for the plugin. If this file is not present the plugin will not be validated by the shell. Example file:
```json
{
  "id": "example",
  "name": "Example Plugin",
  "version": "0.1.0",
  "author": "unknown",
  "description": "A example plugin",
  "img": "https://example.com/preview.png" # This should be a url (tip: use github urls)
}
```
## Initiating other files from the plugin directory
Currently if you try to import or iniatiate a file like this in Main.qml or any other file you'll see a error like:
```qml
qrc:/Main.qml:XX:XX: File(The Other Initiated file) is not a type
```
to fix this problem you can add this into each file which initiates other types:
```qml
property string pluginPath: Directories.shellPlugins + "/nucleus-shell/plugins/examplePlugin"

Component.onCompleted: {
    Qt.application.engine.addImportPath(pluginPath)
}
```

## Overriding Shell's Modules
* If you want to create plugins like: Better-PowerMenu, Better-Bar etc.

You can use the Contracts service to override the modules like this:
```qml
import QtQuick
import Quickshell
import qs.services // For Contracts

Scope {
    Component.onCompleted: { // This is not reactive use Connections to override reactively
        Contracts.overrideBar()
	// you can make a function something like this to make override functions reactive:
        /*
	function overrideReactively() {
		if (!Config.plugins.exampleBetterBarPluginId() {
			return
		Contracts.overrideBar();
	}
	*/
    }
}
```

All the supported override functions: 
```qml
    Contracts.overrideBar();
    Contracts.overridePowermenu();
    Contracts.overrideLauncher();
    Contracts.overrideOverlays();
    Contracts.overrideLockScreen();
    Contracts.overrideNotifications();
    Contracts.overrideBackground();
    Contracts.overrideSidebarRight();
    
    // Overriding any ipc's or globals is not allowed (including settings application)
```

## Plugin Distribution
To distribute your plugin under the shell's database(this repo or other repos).

* Fork this repository and push your plugin to the forked repo. Once you think that your plugin is complete make a PR and wait for you PR to get merged.

* Other custom plugin repo's can be created by the community containing other plugins. If the repository is good enough and has multiple cool plugins it will be added in the plugin fetch utility as a [community] repository. Also note that the repo's should not contain multiple plugins with the same id. If present the repository to have being fetched the same pluginId
will win.
