import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

Item {
    id: item

    property alias text: tooltip.text
    property var container

    anchors.fill: parent

    EaElements.ToolTip {
        id: tooltip

        visible: EaGlobals.Variables.showUserGuides &&
                 EaGlobals.Variables.appBarCurrentIndex === container.appBarCurrentIndex &&
                 container.currentIndex === indexOf(container.contentModel.children, item)

        // Top dots
        guidesCount: container.count
        currentGuideIndex: container.currentIndex

        // Bottom buttons
        controlButtons: [
            EaElements.Button {
                text: qsTr("Previous")
                enabled: container.currentIndex > 0
                onClicked: container.decrementCurrentIndex()
            },

            EaElements.Button {
                text: qsTr("Disable")
                onClicked: EaGlobals.Variables.showUserGuides = false
            },

            EaElements.Button {
                text: qsTr("Next")
                enabled: container.currentIndex < container.count - 1
                onClicked: container.incrementCurrentIndex()
            }
        ]
    }

    // Logic

    function indexOf(model, item) {
        for (let i in model) {
            if (model[i] === item) {
                return parseInt(i)
            }
        }
        return -1
    }
}
