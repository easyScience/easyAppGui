import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

TextInput {
    id: control

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: !enabled ? EaStyle.Colors.themeForegroundDisabled :
                     rippleArea.containsMouse || control.activeFocus ? EaStyle.Colors.themeForegroundHovered :
                                                                       EaStyle.Colors.themeForeground
    Behavior on color {
        EaAnimations.ThemeChange {}
    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: control
        hoverEnabled: true
        onPressed: mouse.accepted = false
    }

}
