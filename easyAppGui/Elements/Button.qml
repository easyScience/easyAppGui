import QtQuick 2.13
import QtQuick.Templates 2.13 as T
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations


T.Button {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    //topInset: 0///6
    //bottomInset: 0///6
    padding: 0//EaStyle.Sizes.fontPixelSize * 0.4///12
    //horizontalPadding: EaStyle.Sizes.fontPixelSize///padding - 4
    spacing: 0

    flat: true

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font

        /*
        color: !control.enabled ?
                   EaStyle.Colors.themeForegroundDisabled :
                   control.highlighted ?
                       EaStyle.Colors.themeAccent :
                       EaStyle.Colors.themeForeground
                       */

        color: !control.enabled ?
                   EaStyle.Colors.themeForegroundDisabled :
                   !rippleArea.containsMouse ?
                       EaStyle.Colors.buttonForeground :
                       !rippleArea.containsPress ?
                           EaStyle.Colors.buttonForegroundHovered :
                           EaStyle.Colors.buttonForegroundPressed
        Behavior on color {
            EaAnimations.ThemeChange {}
        }

    }

    //Mouse area to react on click events
    MouseArea {
        id: rippleArea
        anchors.fill: control
        hoverEnabled: true
        onClicked: control.clicked()
        //onPressed: mouse.accepted = false
    }
}
