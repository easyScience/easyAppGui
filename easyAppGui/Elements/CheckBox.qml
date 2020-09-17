import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.CheckBox {
    id: control

    property color color: EaStyle.Colors.themeAccent

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    spacing: 0//EaGlobals.Sizes.fontPixelSize * 0.5
    padding: 0//EaGlobals.Sizes.fontPixelSize * 0.5
    verticalPadding: 0//padding + EaGlobals.Sizes.fontPixelSize * 0.5

    tristate: false

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    indicator: EaElements.CheckIndicator {
        id: checkIndicator

        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
        y: control.topPadding + (control.availableHeight - height) / 2
        control: control

        //border.width: 1
        //border.color: control.checked ? control.color : EaStyle.Colors.appBarBorder
        //Behavior on border.color {
        //    EaAnimations.ThemeChange {}
        //}

        /*
        Ripple {
            z: -1

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            width: Globals.Sizes.fontPixelSize * 1.5
            height: Globals.Sizes.fontPixelSize * 1.5

            anchor: control
            pressed: control.pressed
            active: control.down || control.visualFocus || control.hovered
            color: control.checked ? control.Material.highlightedRippleColor : control.Material.rippleColor
        }
        */

        Rectangle {
            z: -1
            anchors.centerIn: parent

            implicitWidth: EaGlobals.Sizes.toolButtonHeight
            implicitHeight: EaGlobals.Sizes.toolButtonHeight

            radius: EaGlobals.Sizes.toolButtonHeight * 0.5

            color: rippleArea.containsMouse ?
                       (rippleArea.containsPress ? // TODO: fix this, as currently containsPress is not catched because of onPressed: mouse.accepted = false
                            EaStyle.Colors.appBarButtonBackgroundPressed :
                            EaStyle.Colors.appBarButtonBackgroundHovered) :
                        EaStyle.Colors.appBarButtonBackground
            Behavior on color {
                EaAnimations.ThemeChange {}
            }

            MouseArea {
                id: rippleArea
                anchors.fill: parent
                hoverEnabled: true
                onPressed: mouse.accepted = false
            }
        }
    }

    contentItem: Text {
        leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

        text: control.text
        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        color: control.enabled ?
                   EaStyle.Colors.themeForeground :
                   EaStyle.Colors.themeForegroundDisabled // control.Material.foreground : control.Material.hintTextColor
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }
}
