import QtQuick 2.13
import QtQuick.Controls 2.13
import QtTest 1.13

import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

MouseArea {
    id: mouseArea

    parent: Overlay.overlay // makes buttons background hovered-like !?
    z: 999 // to be above dialog, combobox, etc. windows

    anchors.fill: parent

    hoverEnabled: false
    acceptedButtons: Qt.NoButton

    TestUtil { id: util }
    TestResult { id: result }
    TestEvent { id: event }
    EaElements.RemotePointer { id: pointer }

    // Screenshots

    Timer {
        id: saveScreenshots

        property int i: 1
        property int fps: EaGlobals.Variables.projectConfig.ci.app.tutorials.video.fps
        property string screenshotsDir: EaGlobals.Variables.projectConfig.ci.project.subdirs.screenshots

        running: EaGlobals.Variables.saveScreenshotsRunning

        interval: 1000 / fps
        repeat: true

        onTriggered: {
            const fname = ("00000" + i++).slice(-6)
            const fpath = screenshotsDir + "/" + fname + ".png"
            saveScreenshot(mouseArea, fpath)
        }
    }

    // Controller Logic

    function saveScreenshot(item, path) {
        const image = result.grabImage(item)
        image.save(path)
    }

    function wait(ms) {
        result.wait(ms)
    }

    function show() {
        pointer.posX = mouseArea.width / 2 - pointer.minSize / 2
        pointer.posY = mouseArea.height / 2 - pointer.minSize / 2
        pointer.show()
        wait(pointer.showHideDuration)
    }

    function hide() {
        pointer.hide()
        wait(pointer.showHideDuration)
    }

    function pointerMove(item, x, y, delay, buttons) {
        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (delay === undefined)
            delay = -1
        if (buttons === undefined)
            buttons = Qt.NoButton
        const pos = item.mapToItem(null, x, y)
        pointer.move(pos.x, pos.y)
    }

    function mousePress(item, x, y, button, modifiers, delay) {
        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1
        //print(item, x, y, button)
        //event.mouseMove(item, x, y, button, modifiers, delay)
        event.mouseRelease(item, x, y, button, modifiers, delay)
        event.mousePress(item, x, y, button, modifiers, delay)
        pointer.click()
    }

    function mouseRelease(item, x, y, button, modifiers, delay) {
        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1
        event.mouseRelease(item, x, y, button, modifiers, delay)
    }

    function mouseClick(item, x, y) {
        pointerMove(item, x, y)
        wait(pointer.moveDuration)

        wait(100)

        mousePress(item, x, y)
        wait(pointer.pressDuration)
        mouseRelease(item, x, y)
        wait(pointer.clickRelaxation - pointer.pressDuration)

        wait(500)
    }

    function typeText(text) {
        const modifiers = Qt.NoModifier
        const delay = -1
        for (const c of text) {
            event.keyClickChar(c, modifiers, delay)
            wait(100)
        }
    }

    function clearText(count) {
        const modifiers = Qt.NoModifier
        const delay = -1
        const key = Qt.Key_Backspace//Key_Clear//Key_Delete
        while (count > 0) {
            event.keyClick(key, modifiers, delay)
            wait(100)
            count -= 1
        }
    }

    function keyClick(key) {
        const modifiers = Qt.NoModifier
        const delay = -1
        event.keyClick(key, modifiers, delay)
        wait(500)
    }

}
