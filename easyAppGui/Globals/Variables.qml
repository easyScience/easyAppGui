pragma Singleton

import QtQuick 2.13

QtObject {

    // Python objects
    property var projectConfig: _projectConfig
    property var isTestMode: _isTestMode

    // Debug mode
    property bool isDebugMode: false

    // Initial application parameters
    property int appBarCurrentIndex: 0
    property int appWindowFlags: Qt.Window // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false

    // Initial application components accessibility
    property bool homePageEnabled: isDebugMode ? true : true
    property bool projectPageEnabled: isDebugMode ? true : true
    property bool samplePageEnabled: isDebugMode ? true : true
    property bool experimentPageEnabled: isDebugMode ? true : false
    property bool analysisPageEnabled: isDebugMode ? true : false
    property bool summaryPageEnabled: isDebugMode ? true : false

    // Screenshots control
    property bool saveScreenshotsRunning: false

}
