import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

Rectangle {
    id: statusBar

    //property alias text: label.text
    property alias model: listView.model

    //visible: EaGlobals.Variables.showAppStatusBar

    //Component.onCompleted: y = visible ? 0 : height

    width: parent.width
    height: parent.height

    color: EaStyle.Colors.statusBarBackground
    Behavior on color {
        EaAnimations.ThemeChange {}
    }

    // Status bar main content
    ListView {
        id: listView

        width: statusBar.width
        height: statusBar.height
        spacing: EaStyle.Sizes.fontPixelSize
        orientation: ListView.Horizontal

        model: ListModel {
            ListElement {
                label: "Label1"
                value: "Value1"
            }
            ListElement {
                label: "Label2"
                value: "Value2"
            }
        }

        delegate: EaElements.Label {
            topPadding: (statusBar.height - 3 / 2 * font.pixelSize) * 0.5
            leftPadding: font.pixelSize
            color: EaStyle.Colors.statusBarForeground
            text: model.label + ": " + model.value
        }
    }

    // Fitting label
    Item {
        id: fittingLabel

        property string text: "Fitting"
        property bool running: !ExGlobals.Constants.proxy.isFitFinished
        property color color: EaStyle.Colors.themeForegroundHovered

        visible: running
        width: childrenRect.width
        height: childrenRect.height
        anchors.right: parent.right
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize
        anchors.verticalCenter: parent.verticalCenter

        Row {
            EaElements.Label { text: fittingLabel.text; color: fittingLabel.color }
            EaElements.Label { id: dot1; text: '.'; color: fittingLabel.color }
            EaElements.Label { id: dot2; text: '.'; color: fittingLabel.color }
            EaElements.Label { id: dot3; text: '.'; color: fittingLabel.color }
        }

        SequentialAnimation {
            running: fittingLabel.running
            loops: Animation.Infinite

            SequentialAnimation {
                PropertyAnimation { target: dot1; property: 'opacity'; to: 1; duration: 500 }
                PropertyAnimation { target: dot2; property: 'opacity'; to: 1; duration: 500 }
                PropertyAnimation { target: dot3; property: 'opacity'; to: 1; duration: 500 }
            }

            PauseAnimation { duration: 250 }

            ParallelAnimation {
                PropertyAction { target: dot1; property: 'opacity'; value: 0 }
                PropertyAction { target: dot2; property: 'opacity'; value: 0 }
                PropertyAction { target: dot3; property: 'opacity'; value: 0 }
            }

            PauseAnimation { duration: 250 }
        }
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
