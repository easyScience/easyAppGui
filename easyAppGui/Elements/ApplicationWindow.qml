import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

import MaintenanceTool 1.0


T.ApplicationWindow {
    id: window

    visible: true
    flags: EaGlobals.Variables.appWindowFlags

    x: EaStyle.Sizes.appWindowX
    y: EaStyle.Sizes.appWindowY

    width: EaStyle.Sizes.appWindowWidth
    height: EaStyle.Sizes.appWindowHeight

    minimumWidth: EaStyle.Sizes.appWindowMinimumWidth
    minimumHeight: EaStyle.Sizes.appWindowMinimumHeight

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    // Updater

    MaintenanceTool {
        id: maintainanceTool

        property bool checkNow: false

        onHasUpdateChanged: {
            if (hasUpdate) {
                hasUpdateDialog.open()
            } else {
                print("!!!!", !EaGlobals.Variables.checkUpdateOnAppStart)
                if (!EaGlobals.Variables.checkUpdateOnAppStart) {
                    noUpdateDialog.open()
                }
            }
        }

        Component.onCompleted: EaGlobals.Variables.maintenanceTool = this
    }

    Timer {
        interval: 2000
        repeat: false
        running: EaGlobals.Variables.checkUpdateOnAppStart
        onTriggered: maintainanceTool.checkUpdate()
    }


    EaElements.Dialog {
        id: hasUpdateDialog

        title: qsTr(`A new version of ${ExGlobals.Constants.appName} is available!`)

        EaElements.Label {
            horizontalAlignment: Text.AlignHCenter
            text: qsTr(`${ExGlobals.Constants.appName} ${maintainanceTool.webVersion} is now available. You are\ncurrently using version ${ExGlobals.Constants.appVersion}.\n\nDo you want to restart and install update?`)
        }

        footer: EaElements.DialogButtonBox {
            EaElements.Button {
                text: qsTr("Remind Me Later")
                onClicked: hasUpdateDialog.close()
            }

            EaElements.Button {
                text: qsTr("Install Update Now")
                onClicked: {
                    maintainanceTool.installUpdate()
                    hasUpdateDialog.close()
                }
            }
        }
    }

    EaElements.Dialog {
        id: noUpdateDialog

        title: qsTr('You are up to date!')

        standardButtons: Dialog.Ok

        EaElements.Label {
            horizontalAlignment: Text.AlignHCenter
            text: qsTr(`${ExGlobals.Constants.appName} ${ExGlobals.Constants.appVersion} (${ExGlobals.Constants.appDate}) is currently the\nnewest version available.`)
        }
    }


    // Quit animation

    PropertyAnimation {
        id: quitAnimo
        target: window
        property: 'opacity'
        to: 0
        duration: 150
        alwaysRunToEnd: true
        easing.type: Easing.InCubic
        onFinished: Qt.quit()
    }
    function quit() {
        quitAnimo.start()
    }
}
