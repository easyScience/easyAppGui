import QtQuick 2.13
import QtQuick.Templates 2.13 as T

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Animations 1.0 as EaAnimations

T.ApplicationWindow {
    id: window

    visible: true
    flags: EaGlobals.Variables.appWindowFlags

    x: EaStyle.Sizes.appWindowX
    y: EaStyle.Sizes.appWindowY

    width: EaStyle.Sizes.appWindowWidth
    height: EaStyle.Sizes.appWindowHeight

    minimumWidth: EaStyle.Sizes.appWindowMinimumWidth
    minimumHeight: EaStyle.Sizes.appWindowMinimumHeight

    font.family: EaStyle.Fonts.fontFamily
    font.pixelSize: EaStyle.Sizes.fontPixelSize

    color: EaStyle.Colors.contentBackground
    Behavior on color { EaAnimations.ThemeChange {} }

    PropertyAnimation {
        id: quitAnimo
        target: window
        property: 'opacity'
        to: 0
        duration: 150
        alwaysRunToEnd: true
        easing.type: Easing.InCubic
        onFinished: Qt.quit()
    }
    function quit() {
        quitAnimo.start()
    }
}
