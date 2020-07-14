import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import Globals 1.0 as Globals
import Templates.Animations 1.0 as Animations
import Templates.Controls 1.0

T.TextArea {
    id: control

    implicitWidth: Math.max(contentWidth + leftPadding + rightPadding,
                            implicitBackgroundWidth + leftInset + rightInset,
                            placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(contentHeight + topPadding + bottomPadding,
                             implicitBackgroundHeight + topInset + bottomInset,
                             placeholder.implicitHeight + 1 + topPadding + bottomPadding)

    topPadding: Globals.Sizes.fontPixelSize / 13 * 8
    bottomPadding: Globals.Sizes.fontPixelSize / 13 * 16

    font.family: Globals.Fonts.sans
    font.pixelSize: Globals.Sizes.fontPixelSize

    color: enabled ? Globals.Colors.themeForeground : Globals.Colors.themeForegroundDisabled
    Behavior on color {
        Animations.ThemeChange {}
    }

    selectionColor: Globals.Colors.themeAccent
    Behavior on selectionColor {
        Animations.ThemeChange {}
    }

    selectedTextColor: Globals.Colors.themeAccent//Material.primaryHighlightedTextColor
    Behavior on selectedTextColor {
        Animations.ThemeChange {}
    }

    placeholderTextColor: Globals.Colors.themeForegroundDisabled
    Behavior on placeholderTextColor {
        Animations.ThemeChange {}
    }

    cursorDelegate: CursorDelegate { }

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
        y: parent.height - height - control.bottomPadding / 2
        implicitWidth: 120
        height: control.activeFocus ? 2 : 1

        color: "transparent"//control.activeFocus ? Globals.Colors.themeAccent : Globals.Colors.themeForegroundDisabled //control.Material.accentColor : control.Material.hintTextColor
    }
}
