import QtQuick 2.13
import QtQuick.Controls 2.13
import QtTest 1.13

import easyAppGui.Elements 1.0 as EaElements

MouseArea {
    id: mouseArea

    parent: Overlay.overlay // makes buttons background hovered-like !?
    anchors.fill: parent
    z: 999 // to be above dialog, combobox, etc. windows

    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    TestUtil { id: util }
    TestResult { id: result }
    TestEvent { id: event }
    EaElements.RemotePointer { id: pointer }

    // Controller Logic

    function wait(ms) {
        result.wait(ms)
    }

    function show() {
        pointer.posX = mouseArea.mouseX - pointer.minSize/2
        pointer.posY = mouseArea.mouseY - pointer.minSize/2
        pointer.show()
        wait(pointer.showHideDuration)
    }

    function hide() {
        pointer.hide()
        wait(pointer.showHideDuration)
    }

    function saveScreenshot(item, path) {
        const image = result.grabImage(item)
        image.save(path)
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
