import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             placeholder.implicitHeight + topPadding + bottomPadding)

    topPadding: EaStyle.Sizes.fontPixelSize * 0.5
    bottomPadding: EaStyle.Sizes.fontPixelSize * 0.5

    verticalAlignment: TextInput.AlignVCenter

    color: enabled ? EaStyle.Colors.themeForeground : EaStyle.Colors.themeForegroundDisabled
    Behavior on color {
        EaAnimations.ThemeChange {}
    }

    selectionColor: EaStyle.Colors.themeAccent
    Behavior on selectionColor {
        EaAnimations.ThemeChange {}
    }

    selectedTextColor: EaStyle.Colors.themeBackground
    Behavior on selectedTextColor {
        EaAnimations.ThemeChange {}
    }

    placeholderTextColor: EaStyle.Colors.themeForegroundDisabled
    Behavior on placeholderTextColor {
        EaAnimations.ThemeChange {}
    }

    cursorDelegate: EaElements.CursorDelegate { }

    PlaceholderText {
        id: placeholder
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)
        text: control.placeholderText
        font: control.font
        color: control.placeholderTextColor
        verticalAlignment: control.verticalAlignment
        elide: Text.ElideRight
        renderType: control.renderType
        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
    }

    background: Rectangle {
        y: control.height - height - control.bottomPadding + 8
        implicitWidth: 120
        height: control.activeFocus || control.hovered ? 2 : 1
        color: control.activeFocus ? EaStyle.Colors.themeAccent
                                   : (control.hovered ? EaStyle.Colors.themeForeground : EaStyle.Colors.themeForegroundDisabled)
    }
}
