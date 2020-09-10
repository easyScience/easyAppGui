pragma Singleton

import QtQuick 2.13

QtObject {

    // Python objects
    property var projectConfig: _projectConfig
    property var isTestMode: _isTestMode

    // Initial application parameters
    property int appBarCurrentIndex: 0
    property int appWindowFlags: Qt.Window // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false

    // Screenshots control
    property bool saveScreenshotsRunning: false

}
