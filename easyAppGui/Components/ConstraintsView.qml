import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.XmlListModel 2.13

import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Components 1.0 as EaComponents

import Gui.Globals 1.0 as ExGlobals

ListView {
    id: listView

    property int columnSpacing: EaStyle.Sizes.fontPixelSize * 0.5
    property int rowHeight: EaStyle.Sizes.fontPixelSize * 2.75
    property int maxRowCountShow: 5

    enabled: count > 0

    width: parent.width - EaStyle.Sizes.fontPixelSize * 0.5
    height: count > 0 ?
                rowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                rowHeight * (Math.min(count, maxRowCountShow) + 2 )

    clip: true

    // Table model

    model: XmlListModel {
        xml: ExGlobals.Constants.proxy.constraintsListAsXml
        query: "/root/item"

        onXmlChanged: print(ExGlobals.Constants.proxy.constraintsListAsXml)

        XmlRole { name: "number"; query: "number/number()" }
        XmlRole { name: "dependentName"; query: "dependentName/string()" }
        XmlRole { name: "relationalOperator"; query: "relationalOperator/string()" }
        XmlRole { name: "value"; query: "value/number()" }
        XmlRole { name: "arithmeticOperator"; query: "arithmeticOperator/string()" }
        XmlRole { name: "independentName"; query: "independentName/string()" }
        XmlRole { name: "enabled"; query: "enabled/number()" }
    }

    // Table header

    header: Rectangle {
        width: listView.width
        height: rowHeight

        color: EaStyle.Colors.themeBackground

        Row {
            spacing: columnSpacing
            height: parent.height

            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("numberColumn")
                text: "No."
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                width: columnWidth("dependentNameColumn")
                text: "Constraint"
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("relationalOperatorColumn")
                text: ""
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("valueColumn")
                text: ""
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("arithmeticOperatorColumn")
                text: ""
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                width: columnWidth("independentNameColumn")
                text: ""
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                width: columnWidth("useColumn")
                text: "Use"
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                width: columnWidth("delColumn") - 4
                font.family: EaStyle.Fonts.iconsFamily
                font.pixelSize: EaStyle.Sizes.fontPixelSize * 1.25
                text: "\uf2ed"
            }
        }
    }

    // Table rows

    Rectangle {
        visible: model.count === 0

        width: listView.width
        height: rowHeight
        y: height

        color: EaStyle.Colors.themeBackgroundHovered1

        EaElements.Label {
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: EaStyle.Sizes.fontPixelSize
            text: qsTr("No Constraints Added")
        }
    }

    delegate: Rectangle {
        width: listView.width
        height: rowHeight

        color: model.index % 2 ?
                   EaStyle.Colors.themeBackgroundHovered2 :
                   EaStyle.Colors.themeBackgroundHovered1

        Row {
            spacing: columnSpacing
            height: parent.height

            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("numberColumn")
                text: model.number
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                width: columnWidth("dependentNameColumn")
                text: model.dependentName
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                width: columnWidth("relationalOperatorColumn")
                font.family: EaStyle.Fonts.iconsFamily
                text: model.relationalOperator.replace("=", "\uf52c").replace(">", "\uf531").replace("<", "\uf536")
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("valueColumn")
                text: model.value.toFixed(4)
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                width: columnWidth("arithmeticOperatorColumn")
                font.family: EaStyle.Fonts.iconsFamily
                text: model.arithmeticOperator.replace("*", "\uf00d").replace("/", "\uf529").replace("+", "\uf067").replace("-", "\uf068")
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                width: columnWidth("independentNameColumn")
                text: model.independentName
            }
            EaElements.CheckBox {
                anchors.verticalCenter: parent.verticalCenter
                width: columnWidth("useColumn")
                checked: model.enabled
                onToggled: ExGlobals.Constants.proxy.toggleConstraintByIndex(currentIndex, checked)
            }
            EaElements.SideBarButton {
                anchors.verticalCenter: parent.verticalCenter
                height: columnWidth("delColumn") - 7
                width: columnWidth("delColumn") - 4
                fontIcon: "minus-circle"
                ToolTip.text: qsTr("Remove this constraint")
                onClicked: ExGlobals.Constants.proxy.removeConstraintByIndex(currentIndex)
            }
        }
    }

    // Table border

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: EaStyle.Colors.appBarComboBoxBorder
    }

    // Logic

    function columnWidth(key) {
        const widths = {
            numberColumn: EaStyle.Sizes.fontPixelSize * 2,
            dependentNameColumn: 0, // to be calculated and updated below
            relationalOperatorColumn: EaStyle.Sizes.fontPixelSize * 2,
            valueColumn: EaStyle.Sizes.fontPixelSize * 4,
            independentNameColumn: 0, // to be calculated and updated below
            arithmeticOperatorColumn: EaStyle.Sizes.fontPixelSize * 2,
            useColumn: EaStyle.Sizes.fontPixelSize * 3,
            delColumn: rowHeight
        }

        const fixedColumnsWidth = Object.values(widths).reduce((a, b) => a + b)
        const spacingWidth = columnSpacing * (Object.keys(widths).length - 1)
        const allColumnWidth = listView.width

        const nameColumn = (allColumnWidth - fixedColumnsWidth - spacingWidth) / 2
        widths.dependentNameColumn = nameColumn
        widths.independentNameColumn = nameColumn

        //print(JSON.stringify(widths))
        print(key, widths[key])

        return widths[key]
    }

}
