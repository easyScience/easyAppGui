import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

Rectangle {
    id: statusBar

    property alias text: label.text

    //visible: EaGlobals.Variables.showAppStatusBar

    //Component.onCompleted: y = visible ? 0 : height

    width: parent.width
    height: parent.height

    color: EaStyle.Colors.statusBarBackground
    Behavior on color {
        EaAnimations.ThemeChange {}
    }

    // Status bar text
    Label {
        id: label

        //anchors.verticalCenter: parent.verticalCenter
        //height: parent.height
        //verticalAlignment: Text.AlignVCenter
        topPadding: (statusBar.height - font.pixelSize - 5) * 0.5
        leftPadding: 10

        color: EaStyle.Colors.statusBarForeground
    }

    // Status bar top border
    Rectangle {
        anchors.top: statusBar.top
        anchors.left: statusBar.left
        anchors.right: statusBar.right

        height: 1//EaStyle.Sizes.borderThickness

        color: EaStyle.Colors.appBarBorder
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }

    /*
    // Show-hide status bar animation
    Behavior on visible {
        InterfaceAnimations.BarShow {
            parentTarget: statusBar
        }
    }
    */
}
