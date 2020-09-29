import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle

Rectangle {
    default property alias contentRowData: contentRow.data

    width: parent === null ? 0 : parent.width
    height: EaStyle.Sizes.tableRowHeight

    color: index % 2 ?
               EaStyle.Colors.themeBackgroundHovered2 :
               EaStyle.Colors.themeBackgroundHovered1

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }

    // Highligh row on click
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.ListView.view.currentIndex = index
            mouse.accepted = false
        }
    }
}
