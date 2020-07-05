pragma Singleton

import QtQuick 2.13

QtObject {

    property bool isDebug: false

    // Initial application parameters
    property int appBarCurrentIndex: 0
    property int appWindowFlags: Qt.Window // Qt.FramelessWindowHint | Qt.Dialog

    // Initial application elements visibility
    property bool showAppBar: true
    property bool showAppStatusBar: true
    property bool showAppPreferencesDialog: false

    // Initial application components accessibility
    property bool homePageEnabled: isDebug ? true : true
    property bool projectPageEnabled: isDebug ? true : true
    property bool samplePageEnabled: isDebug ? true : true
    property bool experimentPageEnabled: isDebug ? true : false
    property bool analysisPageEnabled: isDebug ? true : false
    property bool summaryPageEnabled: isDebug ? true : false

    // Screenshots control
    property bool saveScreenshotsRunning: false
    property string screenshotsDir: _screenshotsDir

}
