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
    id: dialog

    visible: EaGlobals.Variables.showAppPreferencesDialog
    onClosed: EaGlobals.Variables.showAppPreferencesDialog = false

    title: qsTr("Preferences")

    standardButtons: Dialog.Ok

    Component.onCompleted: setPreferencesOkButton()

    Column {

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Theme") + ":"
            }

            EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 12
                model: [qsTr("Light"), qsTr("Dark"), qsTr("System")]
                onActivated: {
                    if (currentIndex === 0)
                        EaStyle.Colors.theme = EaStyle.Colors.LightTheme
                    else if (currentIndex === 1)
                        EaStyle.Colors.theme = EaStyle.Colors.DarkTheme
                    else if (currentIndex === 2)
                        EaStyle.Colors.theme = EaStyle.Colors.SystemTheme
                }
                Component.onCompleted: {
                    ExGlobals.Variables.themeSelector = this
                    if (EaStyle.Colors.theme === EaStyle.Colors.LightTheme)
                        currentIndex = 0
                    else if (EaStyle.Colors.theme === EaStyle.Colors.DarkTheme)
                        currentIndex = 1
                    else if (EaStyle.Colors.theme === EaStyle.Colors.SystemTheme)
                        currentIndex = 2
                }
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Zoom") + ":"
            }

             EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 12
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
                width: EaStyle.Sizes.fontPixelSize * 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Language") + ":"
            }

             EaElements.ComboBox {
                 id: languageSelector
                 width: EaStyle.Sizes.fontPixelSize * 12
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
                width: EaStyle.Sizes.fontPixelSize * 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Data plotting") + ":"
            }

             EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 12
                model: ExGlobals.Constants.proxy.plotting1d.libs
                onActivated: ExGlobals.Constants.proxy.plotting1d.currentLib = currentValue

                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.plotting1d.currentLib)
                }
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

             EaElements.Label {
                width: EaStyle.Sizes.fontPixelSize * 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Structure plotting") + ":"
            }

             EaElements.ComboBox {
                width: EaStyle.Sizes.fontPixelSize * 12
                model: ExGlobals.Constants.proxy.plotting3dLibs
                onActivated: ExGlobals.Constants.proxy.current3dPlottingLib = currentValue

                Component.onCompleted: {
                    currentIndex = model.indexOf(ExGlobals.Constants.proxy.current3dPlottingLib)
                }
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            EaElements.Label {
               width: EaStyle.Sizes.fontPixelSize * 9.3
               anchors.verticalCenter: parent.verticalCenter
               text: qsTr("Enable tool tips") + ":"
            }

            EaElements.CheckBox {
                //text: qsTr("Enable tool tips")
                checked: EaGlobals.Variables.showToolTips
                onCheckedChanged: EaGlobals.Variables.showToolTips = checked
                Component.onCompleted: ExGlobals.Variables.enableToolTipsCheckBox = this
            }
        }

        Row {
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            EaElements.Label {
               width: EaStyle.Sizes.fontPixelSize * 9.3
               anchors.verticalCenter: parent.verticalCenter
               text: qsTr("Enable user guides") + ":"
            }

            EaElements.CheckBox {
                //text: qsTr("Enable tool tips")
                checked: EaGlobals.Variables.showUserGuides
                onCheckedChanged: EaGlobals.Variables.showUserGuides = checked
                Component.onCompleted: ExGlobals.Variables.enableUserGuidesCheckBox = this
            }
        }
    }

    // Logic

    function setPreferencesOkButton() {
        const buttons = dialog.footer.contentModel.children
        for (let i in buttons) {
            const button = buttons[i]
            if (button.text === 'OK') {
                ExGlobals.Variables.preferencesOkButton = button
                return
            }
        }
    }
}
