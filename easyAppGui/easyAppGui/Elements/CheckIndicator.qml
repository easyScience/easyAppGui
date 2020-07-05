import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

Rectangle {
    id: indicatorItem

    implicitWidth: EaStyle.Sizes.fontPixelSize
    implicitHeight: EaStyle.Sizes.fontPixelSize

    radius: 2

    color: "transparent"
    ///border.color: !control.enabled ? control.Material.hintTextColor
    ///    : checkState !== Qt.Unchecked ? control.Material.accentColor : control.Material.secondaryTextColor
    border.width: checkState !== Qt.Unchecked ? width / 2 : 2

    property Item control
    property int checkState: control.checkState

    Behavior on border.width {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }

    /*
    Behavior on border.color {
        ColorAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
    }
    */

    EaElements.Label {
        id: checkSymbol

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        text: "\ue800" // ????

        font.family: EaStyle.Fonts.fontFamily
        font.pixelSize: EaStyle.Sizes.fontPixelSize

        scale: indicatorItem.checkState === Qt.Checked ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }

        color: indicatorItem.enabled ?
                   "red" : //EaStyle.Colors.checkSymbol :
                   EaStyle.Colors.themeForegroundDisabled
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }

    Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 12
        height: 3

        scale: indicatorItem.checkState === Qt.PartiallyChecked ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
    }

    states: [
        State {
            name: "checked"
            when: indicatorItem.checkState === Qt.Checked
        },
        State {
            name: "partiallychecked"
            when: indicatorItem.checkState === Qt.PartiallyChecked
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                // Go down 2 pixels in size.
                to: 1 - 2 / indicatorItem.width
                duration: 120
            }
            NumberAnimation {
                target: indicatorItem
                property: "scale"
                to: 1
                duration: 120
            }
        }
    }
}
