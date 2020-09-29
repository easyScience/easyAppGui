import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle

Rectangle {
    default property alias contentRowData: contentRow.data

    z: 2 // To display header above delegate

    width: parent === null ? 0 : parent.width
    height: EaStyle.Sizes.tableRowHeight

    color: EaStyle.Colors.themeBackground

    Row {
        id: contentRow

        height: parent.height
        spacing: EaStyle.Sizes.tableColumnSpacing
    }
}
