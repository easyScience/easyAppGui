pragma Singleton

import QtQuick 2.13

import easyAppGui.Logic 1.0 as EaLogic

QtObject {

    // Python objects
    readonly property var isTestMode: typeof _isTestMode !== "undefined" && _isTestMode !== null ?
                                          _isTestMode :
                                          false

    readonly property var projectConfig: typeof _projectConfig !== "undefined" && _projectConfig !== null ?
                                             _projectConfig :
                                             EaLogic.ProjectConfig.projectConfig()

    // readonly property var translator: typeof _translator !== "undefined" && _translator !== null ?
    //                                       _translator :
    //                                       new EaLogic.Translate.Translator()

    // Initial application parameters
    property int appBarCurrentIndex: 0
    property int appWindowFlags: Qt.Window // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false
    property bool showToolTips: false

    // Screenshots control
    property bool saveScreenshotsRunning: false

}
