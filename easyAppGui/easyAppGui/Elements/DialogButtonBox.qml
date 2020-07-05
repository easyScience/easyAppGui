import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

///import Globals 1.0 as Globals
///import Templates.Animations 1.0 as Animations
///import Templates.Controls 1.0

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements

T.DialogButtonBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 8
    padding: 8
    verticalPadding: 2
    alignment: Qt.AlignRight
    buttonLayout: T.DialogButtonBox.AndroidLayout

    ///Material.foreground: Material.accent

    delegate: EaElements.Button { highlighted: true }

    contentItem: ListView {
        model: control.contentModel
        spacing: control.spacing
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds
        snapMode: ListView.SnapToItem
    }

    // Buttons area
    background: PaddedRectangle {
        ///implicitHeight: control.Material.dialogButtonBoxHeight
        radius: 2
        // Rounded corners should be only at the top or at the bottom
        topPadding: control.position === T.DialogButtonBox.Footer ? -2 : 0
        bottomPadding: control.position === T.DialogButtonBox.Header ? -2 : 0
        clip: true

        color: EaStyle.Colors.dialogBackground
        Behavior on color {
            EaAnimations.ThemeChange {}
        }
    }
}
