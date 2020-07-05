import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

//import Templates.Controls 1.0

T.ToolButton {
    id: control

    property string fontIcon: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                            implicitContentHeight + topPadding + bottomPadding)

    padding: 0
    spacing: 0

    /*
    leftInset: 0
    rightInset: 0
    topInset: 0
    bottomInset: 0
    */

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    //ToolTip.visible: hovered && ToolTip.text !== ""

    /*
    ToolTip {
        text: ToolTip.text
        visible: control.parent.hovered//hovered && ToolTip.text !== ""
    }
    */

    contentItem: IconLabel {
        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: control.font.pixelSize * 1.25

        text: control.fontIcon

        color: !control.enabled ?
                   EaStyle.Colors.themeForegroundDisabled :
                   control.checked || control.highlighted ?
                        EaStyle.Colors.themeAccent :
                        EaStyle.Colors.themeForeground
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }

    background: Rectangle {
        implicitWidth: EaStyle.Sizes.toolButtonHeight
        implicitHeight: EaStyle.Sizes.toolButtonHeight

        radius: EaStyle.Sizes.toolButtonHeight * 0.5

        color: rippleArea.containsMouse ?
                   (rippleArea.containsPress ?
                        EaStyle.Colors.appBarButtonBackgroundPressed :
                        EaStyle.Colors.appBarButtonBackgroundHovered) :
                    EaStyle.Colors.appBarButtonBackground
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
            //onClicked: control.clicked()
            onPressed: mouse.accepted = false
        }
    }
}
