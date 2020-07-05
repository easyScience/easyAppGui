import QtQuick 2.13
import QtQuick.Controls 2.13

import easyAppGui.Elements 1.0 as EaElements

Item {
    id: mainArea

    property alias tabs: tabs.contentData
    property alias items: items.contentData

    anchors.fill: parent

    EaElements.TabBar {
        id: tabs

        anchors.top: mainArea.top
        anchors.left: mainArea.left
        anchors.right: mainArea.right
    }

    SwipeView {
        id: items

        anchors.top: tabs.bottom
        anchors.bottom: mainArea.bottom
        anchors.left: mainArea.left
        anchors.right: mainArea.right

        clip: true
        interactive: false

        currentIndex: tabs.currentIndex
    }

}
