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

    visible: EaGlobals.Variables.showAppAboutDialog

    onClosed: EaGlobals.Variables.showAppAboutDialog = 0

    Column {
        padding: 20
        spacing: 30

        // Application icon, name, version container
        Item {
            id: infoRect
            width: childrenRect.width
            height: childrenRect.height

            Row {
                spacing: 10
                bottomPadding: appIcon.y

                // Application icon
                Image {
                    id: appIcon
                    y: 10
                    width: 75
                    fillMode: Image.PreserveAspectFit
                    source: EaGlobals.Variables.appIconPath
                    antialiasing: true
                    MouseArea {
                        enabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        Connections {
                            onClicked: {
                                Qt.openUrlExternally(EaGlobals.Variables.appUrl)
                                }
                        }                        
                    } // MouseArea                    
                }
                // Application name and version
                Column {
                    spacing: 0

                    // Application name
                    Row {
                        spacing: 3

                        Text {
                            text: EaGlobals.Variables.appPrefixName
                            font.family: EaStyle.Fonts.secondCondensedFontFamily
                            font.weight: Font.ExtraLight
                            font.pixelSize: 50
                            color: "#444"
                        }
                        Text {
                            text: EaGlobals.Variables.appSuffixName
                            font.family: EaStyle.Fonts.secondCondensedFontFamily
                            font.pixelSize: 50
                            color: "#444"
                        }
                    }
                    // Application version
                    Text {
                        id: appVersion
                        anchors.right: parent.right
                        font.family: EaStyle.Fonts.secondExpandedFontFamily
                        //font.weight: Font.Light
                        font.pixelSize: EaStyle.Sizes.fontPixelSize
                        text: "Version %1 (%2)".arg(ExGlobals.Constants.appVersion).arg(ExGlobals.Constants.appDate)
                    }
                }

            }
        }

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
                        onClicked: Qt.openUrlExternally(EaGlobals.Variables.eulaUrl)
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
                    onClicked: Qt.openUrlExternally(EaGlobals.Variables.oslUrl)
                }
            }
        }

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
                text: EaGlobals.Variables.description
            }

            // ESS icon
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 75
                fillMode: Image.PreserveAspectFit
                source: EaGlobals.Variables.essIconPath

                MouseArea {
                    enabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally(EaGlobals.Variables.essUrl)
                }
            }
        }

        // Footer
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: EaStyle.Fonts.fontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize
            color: "#222"
            text: "© 2019-2021 • All rights reserved"
        }
    }

}

