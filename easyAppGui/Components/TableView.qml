import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.XmlListModel 2.13

import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Animations 1.0 as EaAnimations
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Components 1.0 as EaComponents

Column {
    property alias model: listView.model
    property alias delegate: listView.delegate
    property alias currentIndex: listView.currentIndex

    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    property alias defaultInfoText: defaultInfoLabel.text
    property alias titleText: titleLabel.text

    EaElements.Label {
        id: titleLabel

        enabled: false
    }

    ListView {
        id: listView

        property string modelXml: model.xml
        property int modelStatus: model.status
        property int lastCurrentIndex: -1

        //property alias nameLabelText: nameLabel.text

        enabled: count > 0

        width: EaStyle.Sizes.sideBarContentWidth
        height: count > 0 ?
                    EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    EaStyle.Sizes.tableRowHeight * (Math.min(count, maxRowCountShow) + 2 )

        clip: true
        headerPositioning: ListView.OverlayHeader
        boundsBehavior: Flickable.StopAtBounds

        // Highlight current row
        highlightMoveDuration: EaStyle.Sizes.tableHighlightMoveDuration
        highlight: Rectangle {
            z: 2 // To display highlight rect above delegate
            color: listView.count > 1 ? EaStyle.Colors.tableHighlight : "transparent"
            //color: EaStyle.Colors.tableHighlight
        }

        // Default info, if no rows added
        Rectangle {
            visible: model.count === 0

            width: listView.width
            height: EaStyle.Sizes.tableRowHeight * 2

            color: EaStyle.Colors.themeBackground

            EaElements.Label {
                id: defaultInfoLabel

                anchors.verticalCenter: parent.verticalCenter
                leftPadding: EaStyle.Sizes.fontPixelSize
            }
        }

        // Table border
        Rectangle {
            anchors.fill: parent

            color: "transparent"

            border.color: EaStyle.Colors.appBarComboBoxBorder
            Behavior on border.color { EaAnimations.ThemeChange {} }
        }

        // Set focus on click
        MouseArea {
            anchors.fill: parent
            onPressed: {
                forceActiveFocus()
                mouse.accepted = false
            }
        }

        // Create table header
        onCountChanged: {
            if (header !== null)
                return
            if (count > 0) {
                header = createHeader()
                positionViewAtBeginning()
            }
        }

        // Restore current index on xml model changed
        onModelXmlChanged: {
            if (lastCurrentIndex !== currentIndex) {
                lastCurrentIndex = currentIndex
                //positionViewAtBeginning()
            }
        }
        onModelStatusChanged: {
            if (modelStatus !== XmlListModel.Ready)
                return
            if (lastCurrentIndex >= 0 && lastCurrentIndex < count) {
                highlightMoveDuration = 0
                currentIndex = lastCurrentIndex
                highlightMoveDuration = EaStyle.Sizes.tableHighlightMoveDuration
            }
        }

        // Logic

        function createHeader() {
            const tableViewDelegate = listView.contentItem.children[0]
            if (typeof tableViewDelegate === "undefined")
                return null

            const firstTableRow = tableViewDelegate.children[0]
            if (typeof firstTableRow === "undefined")
                return null

            let qmlString = ''
            const cells = firstTableRow.children
            for (let cellIndex in cells) {
                const alignmentTypes = { 1: 'Text.AlignLeft', 2: 'Text.AlignRight', 4: 'Text.AlignHCenter', 8: 'Text.AlignJustify' }
                const horizontalAlignment = alignmentTypes[cells[cellIndex].horizontalAlignment]
                const width = cells[cellIndex].width
                const headerText = cells[cellIndex].headerText
                qmlString +=
                        "EaComponents.TableViewLabel { \n" +
                            `text: '${headerText}' \n` +
                            `width: ${width} \n` +
                            `horizontalAlignment: ${horizontalAlignment} \n` +
                        "} \n"
            }

            qmlString =
                    "import QtQuick 2.13 \n" +
                    "import easyAppGui.Components 1.0 as EaComponents \n" +
                    "Component { \n" +
                        "EaComponents.TableViewHeader { \n" +
                            `${qmlString}` +
                         "} \n" +
                    "} \n"

            const headerObj = Qt.createQmlObject(qmlString, listView)

            return headerObj
        }

        /*
        function calcFlexibleColumnWidth() {
            const tableViewDelegate = listView.contentItem.children[0]
            if (typeof tableViewDelegate === "undefined")
                return

            const firstTableRow = tableViewDelegate.children[0]
            if (typeof firstTableRow === "undefined")
                return

            let fixedColumnsWidth = 0
            const cells = firstTableRow.children
            for (let cellIndex in cells)
                fixedColumnsWidth += cells[cellIndex].width

            const spacingWidth = EaStyle.Sizes.tableColumnSpacing * (cells.length - 1)
            const allColumnWidth = listView.width
            const flexibleColumnWidth = allColumnWidth - fixedColumnsWidth - spacingWidth

            return flexibleColumnWidth
        }

        function updateFlexibleColumnWidth(width) {
            const tableRows = listView.contentItem.children
            for (let rowIndex in tableRows) {
                const tableRow = tableRows[rowIndex].children[0]
                if (typeof tableRow === "undefined")
                    return

                const cells = tableRow.children
                for (let cellIndex in cells)
                    if (cells[cellIndex].width === 0)
                        cells[cellIndex].width = width
            }
        }
        */

    }

}
