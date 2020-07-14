import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

Item {
    id: page

    property alias mainContent: mainContentContainer.data
    property alias sideBar: sideBarContainer.data

    // Main content
    Item {
        id: mainContentContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: sideBarContainer.left

        clip: true
    }

    // Sidebar container
    Item {
        id: sideBarContainer

        anchors.top: page.top
        anchors.bottom: page.bottom
        anchors.right: page.right
        //width: childrenRect.width === border.width ? 0 : EaStyle.Sizes.sideBarWidth
        width: EaStyle.Sizes.sideBarWidth

        clip: true

        // Vertical border on the left side
        Rectangle {
            id: border

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: EaStyle.Sizes.borderThickness

            color: EaStyle.Colors.appBorder
            Behavior on color {
                EaAnimations.ThemeChange {}
            }
        }
    }
}
