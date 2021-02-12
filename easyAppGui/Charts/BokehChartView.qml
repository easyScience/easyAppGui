import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property var measuredData: {'x': '', 'y': ''}
    property var calculatedData: {'x': '', 'y': ''}
    property string xAxisTitle: ''
    property string yAxisTitle: ''
    property color experimentLineColor: 'blue'
    property color calculatedLineColor: 'red'
    property int experimentLineWidth: 2
    property int calculatedLineWidth: 2

    color: 'white'

    WebEngineView {
        id: webView

        anchors.fill: parent
        anchors.margins: EaStyle.Sizes.fontPixelSize * 1.5
        backgroundColor: container.color
    }

    property string html: EaLogic.Plotting.bokehHtml({
        measuredData: measuredData,
        calculatedData: calculatedData,
        chartWidth: (container.width - webView.anchors.margins * 2).toString(),
        chartHeight: (container.height - webView.anchors.margins * 2).toString(),
        chartBackgroundColor: container.color,
        xAxisTitle: xAxisTitle,
        yAxisTitle: yAxisTitle,
        experimentLineColor: experimentLineColor,
        calculatedLineColor: calculatedLineColor,
        experimentLineWidth: experimentLineWidth.toString(),
        calculatedLineWidth: calculatedLineWidth.toString()
    })

    onHtmlChanged: webView.loadHtml(html)
}
