import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

import MaintenanceTool 1.0 as EaUpdate


T.ApplicationWindow {
    id: window

    property string appName: ''
    property string appVersion: ''
    property string appDate: ''

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

    EaUpdate.MaintenanceTool {
        id: maintenanceTool

        onUpdateFound: updateFoundDialog.open()
        onUpdateNotFound: updateNotFoundDialog.open()
        onUpdateFailed: updateFailedDialog.open()

        Component.onCompleted: EaGlobals.Variables.maintenanceTool = this
    }

    // Check update on app start (if needed)

    Timer {
        interval: 2000
        repeat: false
        running: EaGlobals.Variables.checkUpdateOnAppStart
        onTriggered: {
            maintenanceTool.silentCheck = true
            maintenanceTool.checkUpdate()
        }
    }

    // Updater dialogs

    EaElements.Dialog {
        id: updateFoundDialog

        title: qsTr('Update')

        Column {
            spacing: EaStyle.Sizes.fontPixelSize

            EaElements.Label {
                text: qsTr(`A new version of ${appName} is now available!`)
            }

            EaElements.Label {
                text: qsTr(`Current version: ${appVersion}\nAvailable version: ${maintenanceTool.webVersion}\n\nDo you want to restart and install update?`)
            }
        }

        footer: EaElements.DialogButtonBox {
            EaElements.Button {
                text: qsTr("Remind Me Later")
                onClicked: updateFoundDialog.close()
            }

            EaElements.Button {
                text: qsTr("Install Update Now")
                onClicked: maintenanceTool.installUpdate()
            }
        }
    }

    EaElements.Dialog {
        id: updateNotFoundDialog

        title: qsTr('Update')

        standardButtons: Dialog.Ok

        Column {
            spacing: EaStyle.Sizes.fontPixelSize

            EaElements.Label {
                text: qsTr('You are up to date!')
            }

            EaElements.Label {
                text: qsTr(`${appName} ${appVersion} (${appDate})\nis currently the newest version available.`)
            }
        }
    }

    EaElements.Dialog {
        id: updateFailedDialog

        title: qsTr('Update')

        standardButtons: Dialog.Ok

        Column {
            spacing: EaStyle.Sizes.fontPixelSize

            EaElements.Label {
                text: qsTr('An error occurred while checking for updates:')
            }

            EaElements.Label {
                text: maintenanceTool.errorMessage
            }
        }
    }

    // Quit animation

    PropertyAnimation {
        id: quitAnimo

        target: window

        property: 'opacity'
        to: 0

        duration: 150
        easing.type: Easing.InCubic

        alwaysRunToEnd: true

        onFinished: Qt.quit()
    }

    function quit() {
        quitAnimo.start()
    }
}
