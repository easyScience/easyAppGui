import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations

T.Label {
    id: control

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: enabled ? EaStyle.Colors.themeForeground : EaStyle.Colors.themeForegroundDisabled //Material.foreground : Material.hintTextColor
    Behavior on color {
        EaAnimations.ThemeChange {}
    }

    linkColor: EaStyle.Colors.themeAccent
    Behavior on linkColor {
        EaAnimations.ThemeChange {}
    }
}
