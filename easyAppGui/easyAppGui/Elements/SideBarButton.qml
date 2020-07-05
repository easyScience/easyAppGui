import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.Button {
    id: control

    property var iconFontFamily: EaStyle.Fonts.iconsFamily
    property var iconFontPixelSize: font.pixelSize * 1.25
    property string fontIcon: ""

    property color textColor: !enabled ?
                                  EaStyle.Colors.themeForegroundDisabled :
                                  checked || down ?
                                      EaStyle.Colors.themeAccent :
                                      EaStyle.Colors.themeForeground
    //property color backgroundColor: value

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0

    padding: 0

    spacing: EaStyle.Sizes.fontPixelSize * 0.5

    //flat: true

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    EaElements.ToolTip {
        //parent: control
        text: control.ToolTip.text
        visible: control.hovered && text !== ""
    }

    // Icon with text label
    contentItem: Item {
        Row {
            spacing: control.spacing
            anchors.centerIn: parent

            // Icon
            Label {
                font.family: iconFontFamily
                font.pixelSize: iconFontPixelSize

                text: control.fontIcon

                color: control.textColor
                Behavior on color {
                    EaAnimations.ThemeChange {}
                }
            }

            // Text label
            Label {
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize

                text: control.text

                color: control.textColor
                Behavior on color {
                    EaAnimations.ThemeChange {}
                }
            }
        }
    }

    // Background
    background: Rectangle {
        implicitWidth: EaStyle.Sizes.sideBarButtonWidth - 2 * EaStyle.Sizes.sideBarPadding
        implicitHeight: EaStyle.Sizes.sideBarButtonHeight

        radius: 2

        color: rippleArea.containsMouse ?
                   (rippleArea.containsPress ?
                        EaStyle.Colors.sideBarButtonBackgroundPressed :
                        EaStyle.Colors.sideBarButtonBackgroundHovered) :
                    EaStyle.Colors.sideBarButtonBackground
        Behavior on color {
            PropertyAnimation {
                duration: rippleArea.containsMouse ? 500 : 0 //Globals.Variables.themeChangeTime
                alwaysRunToEnd: true
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            id: rippleArea
            anchors.fill: parent
            hoverEnabled: true
            onPressed: mouse.accepted = false
        }
    }

}

