import QtQuick 2.13
import Qt.labs.settings 1.0

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Components 1.0 as EaComponents

import Gui.Pages.Home 1.0 as ExHomePage

EaElements.ApplicationWindow {
    id: appWindow

    property alias appBarLeftButtons: appBarLeftButtons.data
    property alias appBarCentralTabs: appBarCentralTabs.contentData
    property alias appBarRightButtons: appBarRightButtons.data
    property alias contentArea: contentArea.contentData
    property alias statusBar: statusBarContainer.data

    ////////////////
    // App container
    ////////////////

    Rectangle {
        id: appContainer

        anchors.fill: parent

        color: appWindow.color

        // Application bar container
        Rectangle {
            id: appBar

            anchors.top: appContainer.top
            anchors.left: appContainer.left
            anchors.right: appContainer.right
            height: EaStyle.Sizes.appBarHeight

            color: EaStyle.Colors.appBarBackground

            EaComponents.AppBarLeftButtons {
                id: appBarLeftButtons

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: EaStyle.Sizes.fontPixelSize * 1.0
                anchors.leftMargin: EaStyle.Sizes.fontPixelSize
            }

            EaComponents.AppBarCentralTabs {
                id: appBarCentralTabs

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom

                currentIndex: EaGlobals.Variables.appBarCurrentIndex
                onCurrentIndexChanged: EaGlobals.Variables.appBarCurrentIndex = currentIndex
            }

            EaComponents.AppBarRightButtons {
                id: appBarRightButtons

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: EaStyle.Sizes.fontPixelSize * 1.0
                anchors.rightMargin: EaStyle.Sizes.fontPixelSize
            }

            // tabs bottom border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: EaStyle.Sizes.borderThickness
                color: EaStyle.Colors.appBarBorder
                Behavior on color {
                    EaAnimations.ThemeChange {}
                }
            }
        }

        // Content area container
        EaComponents.ContentArea {
            id: contentArea

            anchors.top: appBar.bottom
            anchors.bottom: statusBarContainer.top
            anchors.left: appContainer.left
            anchors.right: appContainer.right

            currentIndex: appBarCentralTabs.currentIndex
        }

        // Status bar container
        Item {
            id: statusBarContainer

            anchors.bottom: appContainer.bottom
            anchors.left: appContainer.left
            anchors.right: appContainer.right
            height: EaStyle.Sizes.statusBarHeight
        }
    }

    ///////////////
    // Init dialogs
    ///////////////

    // Application dialogs (invisible at the beginning)
    EaComponents.PreferencesDialog {}
    ExHomePage.AboutDialog {}

    ///////////
    // Settings
    ///////////

    Settings {
        fileName: 'settings.ini'
        category: 'AppGeometry'
        property alias x: appWindow.x
        property alias y: appWindow.y
        property alias width: appWindow.width
        property alias height: appWindow.height
    }
}
