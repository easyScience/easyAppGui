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

    width: parent.width - EaStyle.Sizes.fontPixelSize * 0.5
    height: rowHeight * (Math.min(count, maxRowCountShow) + 1)

    clip: true

    // Table model

    /*
    model: ListModel {
        ListElement {
            number: "1"
            label: "Fe3O4 cell length_a"
            value: "8.5700"
            unit: "A"
            error: "0.0324"
            fit: true
        }
        ListElement {
            number: "2"
            label: "Fe3O4 atom_site Fe3A occupancy"
            value: "1.0000"
            unit: "frac"
            error: ""
            fit: false
        }
        ListElement {
            number: "3"
            label: "PolNPD5T setup wavelength"
            value: "2.4000"
            unit: "A"
            error: ""
            fit: false
        }
    }
    */

    model: XmlListModel {
        xml: ExGlobals.Constants.proxy.fitablesModelAsXml
        query: "/root/item"

        XmlRole { name: "number"; query: "number/number()" }
        XmlRole { name: "label"; query: "label/string()" }
        XmlRole { name: "value"; query: "value/number()" }
        XmlRole { name: "unit"; query: "unit/string()" }
        XmlRole { name: "error"; query: "error/number()" }
        XmlRole { name: "fit"; query: "fit/number()" }
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
                width: columnWidth("labelColumn")
                text: "Label"
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("valueColumn")
                text: "Value"
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                width: columnWidth("unitColumn")
                text: ""
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("errorColumn")
                text: "Error"
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                width: columnWidth("fitColumn")
                text: "Fit"
            }
        }
    }

    // Table rows

    delegate: Rectangle {
        width: listView.width
        height: rowHeight

        color: index % 2 ?
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
                width: columnWidth("labelColumn")
                text: model.label
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("valueColumn")
                text: model.value.toFixed(4)
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                width: columnWidth("unitColumn")
                text: model.unit
            }
            EaElements.Label {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignRight
                width: columnWidth("errorColumn")
                text: !fitCheckBox.checked || model.error === 0.0 ? "" : model.error.toFixed(4)
            }
            EaElements.CheckBox {
                id: fitCheckBox
                anchors.verticalCenter: parent.verticalCenter
                width: columnWidth("fitColumn")
                checked: model.fit
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
            labelColumn: 0, // to be calculated and updated below
            valueColumn: EaStyle.Sizes.fontPixelSize * 4,
            unitColumn: EaStyle.Sizes.fontPixelSize,
            errorColumn: EaStyle.Sizes.fontPixelSize * 4,
            fitColumn: EaStyle.Sizes.fontPixelSize * 3
        }

        const fixedColumnsWidth = Object.values(widths).reduce((a, b) => a + b)
        const spacingWidth = columnSpacing * (Object.keys(widths).length - 1)
        const allColumnWidth = listView.width

        widths.labelColumn = allColumnWidth - fixedColumnsWidth - spacingWidth

        return widths[key]
    }

}
