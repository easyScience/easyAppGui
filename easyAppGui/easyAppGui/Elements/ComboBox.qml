import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    topInset: EaStyle.Sizes.fontPixelSize * 0.5
    bottomInset: EaStyle.Sizes.fontPixelSize * 0.5

    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    flat: true
    hoverEnabled: true
    editable: false

    delegate: EaElements.MenuItem {
        width: parent.width
        height: EaStyle.Sizes.comboBoxHeight

        text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        ///Material.foreground: control.currentIndex === index ? parent.Material.accent : parent.Material.foreground
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled
    }

    indicator: Label {
        x: control.mirrored ? control.padding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        text: "\uf0d7"

        font.family: EaStyle.Fonts.iconsFamily
        font.pixelSize: EaStyle.Sizes.fontPixelSize

        ///color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        color: control.enabled ? EaStyle.Colors.themeForeground :  EaStyle.Colors.themeForegroundDisabled
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }

    contentItem: T.TextField {
        padding: EaStyle.Sizes.fontPixelSize * 0.5
        leftPadding: control.editable ? 2 : control.mirrored ? 0 : 12
        rightPadding: control.editable ? 2 : control.mirrored ? 12 : 0

        /////height: 20

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator

        font: control.font
        verticalAlignment: Text.AlignVCenter

        ///selectionColor: control.Material.accentColor
        ///selectedTextColor: control.Material.primaryHighlightedTextColor

        ///color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
        color: control.enabled ? EaStyle.Colors.themeForeground :  EaStyle.Colors.themeForegroundDisabled
        Behavior on color {
            EaAnimations.ThemeChange {}
        }

        cursorDelegate: CursorDelegate { }
    }

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: EaStyle.Sizes.comboBoxHeight

        radius: control.flat ? 0 : 2

        ///color: !control.editable ? control.Material.dialogColor : "transparent"
        color: control.hovered ?
                   (control.pressed ?
                        EaStyle.Colors.appBarComboBoxBackgroundPressed :
                        EaStyle.Colors.appBarComboBoxBackgroundHovered) :
                    EaStyle.Colors.appBarComboBoxBackground
        Behavior on color {
            EaAnimations.ThemeChange {}
        }

        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color {
            EaAnimations.ThemeChange {}
        }
    }

    popup: T.Popup {
        y: control.editable ? control.height - 5 : 0
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: EaStyle.Sizes.fontPixelSize
        bottomMargin: EaStyle.Sizes.fontPixelSize

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: 2
            color: EaStyle.Colors.dialogBackground
            Behavior on color {
                PropertyAnimation {
                    duration: EaStyle.Times.themeChange
                    alwaysRunToEnd: true
                    easing.type: Easing.OutQuint
                }
            }

            layer.enabled: control.enabled
            layer.effect: EaElements.ElevationEffect {
                elevation: 8
            }
        }
    }
}
