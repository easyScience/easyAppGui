import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations


T.ToolTip {
    id: control

    property color textColor: EaStyle.Colors.themeForeground
    property color backgroundColor: EaStyle.Colors.dialogBackground
    property color borderColor: EaStyle.Colors.themePrimary
    property int borderRadius: 2
    property real backgroundOpacity: 0.9

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - EaStyle.Sizes.fontPixelSize

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    margins: EaStyle.Sizes.fontPixelSize
    padding: EaStyle.Sizes.fontPixelSize * 0.75
    horizontalPadding: EaStyle.Sizes.fontPixelSize * 1.15

    closePolicy: T.Popup.CloseOnEscape |
                 T.Popup.CloseOnPressOutsideParent |
                 T.Popup.CloseOnReleaseOutsideParent

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    contentItem: Label {
        font: control.font
        text: control.text

        color: control.textColor
    }

    background: Rectangle {
        implicitHeight: EaStyle.Sizes.tooltipHeight

        opacity: backgroundOpacity

        color: backgroundColor
        border.color: borderColor

        radius: borderRadius
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: 500
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
            easing.type: Easing.InQuad
            duration: 500
        }
    }
}

