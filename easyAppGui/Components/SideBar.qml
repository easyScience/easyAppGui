import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.Material 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

Item {
    id: sideBarContainer

    property alias basicControls: basicControlsContainer.data
    property alias advancedControls: advancedControlsContainer.data

    anchors.fill: parent

    // Sidebar tabs
    EaElements.TabBar {
        id: sideBarTabs

        anchors.top: sideBarContainer.top
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        // Basic controls tab button
        EaElements.TabButton {
            text: qsTr("Basic controls")
        }

        // Advanced controls tab button
        EaElements.TabButton {
            text: qsTr("Advanced controls")
        }

        // Empty background with border
        background: Item {

            // Sidebar tabs bottom border
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: EaStyle.Sizes.borderThickness
                color: EaStyle.Colors.appBorder
                Behavior on color {
                    EaAnimations.ThemeChange {}
                }
            }
        }
    }

    // Sidebar content
    SwipeView {
        id: sideBarContent

        anchors.top: sideBarTabs.bottom
        anchors.bottom: sideBarContainer.bottom
        anchors.left: sideBarContainer.left
        anchors.right: sideBarContainer.right

        //anchors.margins: 0
        padding: 0

        clip: true
        interactive: false

        currentIndex: sideBarTabs.currentIndex

        // Basic controls area
        Flickable {
            contentHeight: basicControlsContainer.height
            contentWidth: basicControlsContainer.width

            clip: true
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                interactive: false
            }

            Column {
                id: basicControlsContainer

                width: sideBarContainer.width
            }
        }

        // Advanced controls area
        Flickable {
            contentHeight: advancedControlsContainer.height
            contentWidth: advancedControlsContainer.width

            clip: true
            flickableDirection: Flickable.VerticalFlick

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                interactive: false
            }

            Column {
                id: advancedControlsContainer

                width: sideBarContainer.width
            }
        }
    }
}
