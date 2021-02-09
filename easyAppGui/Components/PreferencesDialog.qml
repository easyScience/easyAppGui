import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Controls.impl 2.13
import QtQuick.Controls.Material 2.13
import QtQuick.Controls.Material.impl 2.13
import QtQuick.XmlListModel 2.13

//import easyInterface.QtQuick 1.0 as InterfaceQtQuick
//import easyInterface.Globals 1.0 as InterfaceGlobals

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Globals 1.0 as EaGlobals
import easyAppGui.Elements 1.0 as EaElements

import Gui.Globals 1.0 as ExGlobals

EaElements.Dialog {
    //anchors.centerIn: parent

    title: qsTr("Preferences")

    visible: EaGlobals.Variables.showAppPreferencesDialog
    onClosed: EaGlobals.Variables.showAppPreferencesDialog = false

    modal: true
    standardButtons: Dialog.Ok

    Column {
        //spacing: Globals.Sizes.fontPixelSize * 0.25

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 8
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Theme") + ":"
            }

            EaElements.ComboBox {
                id: themeSelector
                width: EaStyle.Sizes.fontPixelSize * 9
                model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                //currentIndex: EaStyle.Colors.isDarkTheme ? 0 : 1 // EaStyle.Colors.theme === EaStyle.Colors.DarkTheme ? 0 : 1
                onCurrentIndexChanged: {
                    if (currentIndex === 0 && EaStyle.Colors.theme !== EaStyle.Colors.LightTheme) {
                        EaStyle.Colors.theme = EaStyle.Colors.LightTheme
                    } else if (currentIndex === 1 && EaStyle.Colors.theme !== EaStyle.Colors.DarkTheme) {
                        EaStyle.Colors.theme = EaStyle.Colors.DarkTheme
                    } else if (currentIndex === 2 && EaStyle.Colors.theme !== EaStyle.Colors.LightTheme) {
                        EaStyle.Colors.theme = EaStyle.Colors.systemTheme
                    }
                }
                Component.onCompleted: ExGlobals.Variables.themeSelector = themeSelector
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 8
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Zoom") + ":"
            }

             EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 9
                model: ["100%", "110%", "120%", "130%", "140%", "150%"]
                onCurrentTextChanged: {
                    if (parseInt(currentText) === EaStyle.Sizes.defaultScale) {
                        return
                    }
                    EaStyle.Sizes.defaultScale = parseInt(currentText)
                }
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 8
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Language") + ":"
            }

             EaElements.ComboBox {
                 id: languageSelector
                 width: EaStyle.Sizes.fontPixelSize * 9
                 model: XmlListModel {
                     xml: EaGlobals.Variables.translator.languagesAsXml()
                     query: "/root/item"
                     XmlRole {
                         name: "name"
                         query: "name/string()"
                     }
                     onStatusChanged: {
                         if (status === XmlListModel.Ready) {
                             languageSelector.currentIndex = EaGlobals.Variables.translator.defaultLanguageIndex()
                         }
                     }
                 }
                onActivated: EaGlobals.Variables.translator.selectLanguage(currentIndex)
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 8
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Data plotting") + ":"
            }

             EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 9
                model: ExGlobals.Constants.proxy.plotting1dLibs
                onActivated: ExGlobals.Constants.proxy.current1dPlottingLib = currentValue

                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.current1dPlottingLib)
                }
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            EaElements.Label {
               width: EaStyle.Sizes.fontPixelSize * 5.3
               anchors.verticalCenter: parent.verticalCenter
               text: qsTr("Tool tips") + ":"
            }

            EaElements.CheckBox {
                //text: qsTr("Enable tool tips")
                checked: EaGlobals.Variables.showToolTips
                onCheckedChanged: EaGlobals.Variables.showToolTips = checked
            }
        }
    }
}
