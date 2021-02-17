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

    title: qsTr("About")

    parent: Overlay.overlay

    x: (parent.width - width) * 0.5
    y: (parent.height - height) * 0.5

    modal: true
    standardButtons: Dialog.Ok

    Column {
        padding: EaStyle.Sizes.fontPixelSize * 0.5
        spacing: EaStyle.Sizes.fontPixelSize * 2.5

        // Application icon, name, version container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: -EaStyle.Sizes.fontPixelSize * 0.5

            Row {
                // App icon
                EaElements.LinkedImage {
                    height: EaStyle.Sizes.fontPixelSize * 5
                    source: appIconPath
                    link: appUrl
                }

                // Horizontal spacer
                Item { width: EaStyle.Sizes.fontPixelSize; height: 1 }

                // App name
                EaElements.Label {
                    text: appPrefixName
                    font.family: EaStyle.Fonts.secondCondensedFontFamily
                    font.weight: Font.ExtraLight
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3.5
                }

                EaElements.Label {
                    text: appSuffixName
                    font.family: EaStyle.Fonts.secondCondensedFontFamily
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3.5
                }
            }

            // Application version
            EaElements.Label {
                anchors.right: parent.right
                font.family: EaStyle.Fonts.secondExpandedFontFamily
                text: "Version %1 (%2)".arg(appVersion).arg(appDate)
            }
        }

        // EULA and licences container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // EULA
            EaElements.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: true
                text: "End User Licence Agreement"
                onClicked: Qt.openUrlExternally(eulaUrl)
            }

            // Licences
            EaElements.Button {
                anchors.horizontalCenter: parent.horizontalCenter
                checked: true
                text: "Dependent Open Source Licenses"
                onClicked: Qt.openUrlExternally(oslUrl)
            }
        }

        // Description container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // Text
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: description
            }

            // ESS icon
            EaElements.LinkedImage {
                anchors.horizontalCenter: parent.horizontalCenter
                height: EaStyle.Sizes.fontPixelSize * 5
                source: essIconPath
                link: essUrl
            }
        }

        // Footer
        EaElements.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "© 2019-2021 • All rights reserved"
        }
    }

}

