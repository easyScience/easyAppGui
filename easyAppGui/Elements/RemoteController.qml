import QtQuick 2.14
import QtQuick.Controls 2.14
import QtMultimedia 5.14
import QtTest 1.14

import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

MouseArea {
    id: mouseArea

    property bool sayEnabled: true
    property string audioDir: ""

    parent: Overlay.overlay // makes buttons background hovered-like !?
    z: 999 // to be above dialog, combobox, etc. windows

    anchors.fill: parent

    //hoverEnabled: true
    hoverEnabled: false
    acceptedButtons: Qt.NoButton

    TestUtil { id: util }
    TestResult { id: result }
    TestEvent { id: event }
    EaElements.RemotePointer { id: pointer }

    // Audio

    Audio {
        id: audio

        onDurationChanged: {
            play()
            wait(audio.duration)
        }
    }

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

    function say(text) {
        if (!sayEnabled)
            return
        if (text === "")
            return
        const fileName = text.replace(/ /g, "_")
        audio.source = `${audioDir}/${fileName}.mp3`
        wait(1000) // Needed for smooth pointer movement
    }

    function saveScreenshot(item, path) {
        const image = result.grabImage(item)
        image.save(path)
    }

    function wait(ms) {
        result.wait(ms)
    }

    function posToCenter() {
        pointer.posX = mouseArea.width / 2 - pointer.minSize / 2
        pointer.posY = mouseArea.height / 2 - pointer.minSize / 2
    }

    function show() {
        pointer.show()
        wait(pointer.showHideDuration)
    }

    function hide() {
        pointer.hide()
        wait(pointer.showHideDuration)
    }

    function pointerMove(item, x, y, delay, buttons) {
        if (item === undefined) {
            print("Undefined item")
            return
        }

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
        if (item === undefined) {
            print("Undefined item")
            return
        }

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

        //event.mouseMove(item, x, y, button, modifiers, delay)
        //event.mouseRelease(item, x, y, button, modifiers, delay)
        event.mousePress(item, x, y, button, modifiers, delay)
        pointer.click()
    }

    function mouseRelease(item, x, y, button, modifiers, delay) {
        if (item === undefined) {
            print("Undefined item")
            return
        }

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

    function mouseLeftClickSilent(item) {
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.LeftButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseRightClickSilent(item) {
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.RightButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseMove(item) {
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.NoButton
        const delay = -1

        event.mouseMove(item, x, y, delay, button)
    }

    function mouseWheel(item) {
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const xDelta = 0
        const yDelta = 120  // 120 units * 1/8 = 15 degrees
        const button = Qt.NoButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseWheel(item, x, y, button, modifiers, xDelta, yDelta, delay) // ?
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
