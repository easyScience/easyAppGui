import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13
import QtQuick.XmlListModel 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals


EaElements.Dialog {
    id: aboutDialog
    title: "About"

    property string appIconPath: ""
    property string appUrl: ""
    property string appPrefixName: ""
    property string appSuffixName: ""
    property string appVersion: ""
    property string appDate: ""
    property string eulaUrl: ""
    property string oslUrl: ""
    property string essIconPath: ""
    property string essUrl: ""
    property string description: ""

    Column {
        padding: EaStyle.Sizes.fontPixelSize * 2.0
        spacing: EaStyle.Sizes.fontPixelSize * 0.5

        // Application icon, name, version container
        Item {
            id: infoRect
            width: childrenRect.width
            height: childrenRect.height

            Row {
                spacing: 10

                // Application icon
                EaElements.LinkedImage {
                    source: appIconPath
                    y: 10
                    width: 75
                    link: appUrl
                } // Image

                // Application name and version
                Column {
                    spacing: 0

                    // Application name
                    Row {
                        spacing: 3

                        Text {
                            text: appPrefixName
                            font.family: EaStyle.Fonts.secondCondensedFontFamily
                            font.weight: Font.ExtraLight
                            font.pixelSize: 50
                            color: "#444"
                        }
                        Text {
                            text: appSuffixName
                            font.family: EaStyle.Fonts.secondCondensedFontFamily
                            font.pixelSize: 50
                            color: "#444"
                        }
                    } // Row
                    // Application version
                    Text {
                        id: idVersion
                        anchors.right: parent.right
                        font.family: EaStyle.Fonts.secondExpandedFontFamily
                        font.pixelSize: EaStyle.Sizes.fontPixelSize
                        text: "Version %1 (%2)".arg(appVersion).arg(appDate)
                    }
                } // Column

            } // Row
        } // Item

        // Eula and licences container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
                // EULA
            EaElements.Label  {
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: EaStyle.Fonts.secondFontFamily
                    font.pixelSize: EaStyle.Sizes.fontPixelSize
                    text: "End User Licence Agreement"
                    color: EaStyle.Colors.linkColor
                    MouseArea {
                        enabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(eulaUrl)
                    } // MouseArea
                } // Label

            // Licences
           EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: EaStyle.Fonts.fontFamily
                font.pixelSize: EaStyle.Sizes.fontPixelSize
                text: "Dependent Open Source Licenses"
                color: EaStyle.Colors.linkColor
                MouseArea {
                    enabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally(oslUrl)
                }
            } // Label
        } // Column

        // Description container
        Column {
            id: descriptionContainer
            width: infoRect.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            Text {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: TextEdit.WordWrap
                font.family: EaStyle.Fonts.fontFamily
                font.pixelSize: EaStyle.Sizes.fontPixelSize
                color: "#222"
                text: description
            }

            // ESS icon
            EaElements.LinkedImage {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 75
                source: essIconPath
                link: essUrl
            }  // Image
        } // Column

        // Footer
        EaElements.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#222"
            text: "© 2019-2021 • All rights reserved"
        }
    } // Column

} // Dialog

