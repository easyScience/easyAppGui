import QtQuick 2.13
import QtQuick.Controls 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Logic 1.0 as EaLogic

import Gui.Globals 1.0 as ExGlobals

Rectangle {
    id: container

    property string cifStr: ""
    onCifStrChanged: chartView.runJavaScript(`reloadCif(${cifStr})`)

    //property int size: Math.min(width, height)
    //onWidthChanged: setChartSizes()
    //onHeightChanged: setChartSizes()

    property int appScale: EaStyle.Sizes.defaultScale
    onAppScaleChanged: setChartSizes()

    property int theme: EaStyle.Colors.theme
    onThemeChanged: setChartColors()

    color: EaStyle.Colors.chartPlotAreaBackground

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.margins: 0

        backgroundColor: parent.color

        url: 'BaseChemDoodle.html'

        onLoadingChanged: {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                hideChartToolbar()
                setChartSizes()
                setChartColors()
                reloadCif()
            }
        }

        onContextMenuRequested: {
            request.accepted = true
        }

        Component.onCompleted: ExGlobals.Variables.bokehStructureChart = this
    }

    /////////////////////
    // Chart tool buttons
    /////////////////////

    Row {
        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: EaStyle.Sizes.fontPixelSize
        anchors.rightMargin: EaStyle.Sizes.fontPixelSize

        spacing: 0.25 * EaStyle.Sizes.fontPixelSize

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "bone"
            ToolTip.text: checked ? qsTr("Hide bonds") : qsTr("Show bonds")
            onClicked: chartView.runJavaScript("showBondsAction()")
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "tag"
            ToolTip.text: checked ? qsTr("Hide labels") : qsTr("Show labels")
            onClicked: chartView.runJavaScript("showLabelsAction()")
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "cube"
            ToolTip.text: checked ? qsTr("Set orthographic view") : qsTr("Set perspective view")
            onClicked: chartView.runJavaScript("changeProjectionTypeAction()")
        }

        Item {
            height: 1
            width: parent.spacing
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "x"
            ToolTip.text: qsTr("View along the x axis")
            onClicked: chartView.runJavaScript("xProjectionAction()")
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "y"
            ToolTip.text: qsTr("View along the y axis")
            onClicked: chartView.runJavaScript("yProjectionAction()")
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "z"
            ToolTip.text: qsTr("View along the z axis")
            onClicked: chartView.runJavaScript("zProjectionAction()")
        }

        EaElements.TabButton {
            checkable: false
            autoExclusive: false
            height: EaStyle.Sizes.toolButtonHeight
            width: EaStyle.Sizes.toolButtonHeight
            borderColor: EaStyle.Colors.chartAxis
            fontIcon: "home"
            ToolTip.text: qsTr("Reset to default view")
            onClicked: chartView.runJavaScript("defaultViewAction()")
        }
    }

    // Logic

    function getSource(){
        var js = "document.documentElement.outerHTML"
        chartView.runJavaScript(js, function(result){console.log(result)})
    }

    function hideChartToolbar() {
        chartView.runJavaScript(`showToolbar(false)`)
    }

    function reloadCif() {
        chartView.runJavaScript(`reloadCif(${cifStr})`)
    }

    function setChartSizes() {
        const sizes = {
            '--chartWidth': chartView.width,
            '--chartHeight': chartView.height,
            '--fontPixelSize': EaStyle.Sizes.fontPixelSize,
            '--toolButtonHeight': EaStyle.Sizes.toolButtonHeight
        }
        for (let key in sizes) {
            chartView.runJavaScript(`document.documentElement.style.setProperty('${key}', '${sizes[key]}')`)
        }
        chartView.runJavaScript(`setChartSizesExtra()`)
    }

    function setChartColors() {
        const colors = {
            '--backgroundColor': EaStyle.Colors.chartPlotAreaBackground,
            '--foregroundColor': EaStyle.Colors.chartForeground,
            '--buttonBackgroundColor': EaStyle.Colors.contentBackground,
            '--buttonBackgroundHoveredColor': EaStyle.Colors.themeBackgroundHovered1,
            '--buttonForegroundColor': EaStyle.Colors.themeForeground,
            '--buttonForegroundHoveredColor': EaStyle.Colors.themeForegroundHovered,
            '--buttonBorderColor': EaStyle.Colors.chartAxis,
            '--tooltipBackgroundColor': EaStyle.Colors.dialogBackground,
            '--tooltipForegroundColor': EaStyle.Colors.themeForeground,
            '--tooltipBorderColor': EaStyle.Colors.themePrimary
        }
        for (let key in colors) {
            chartView.runJavaScript(`document.documentElement.style.setProperty('${key}', '${colors[key]}')`)
        }
        chartView.runJavaScript(`setChartColorsExtra()`)
    }

}
