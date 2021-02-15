import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property var measuredData: {'x': undefined, 'y': undefined}
    property var calculatedData: {'x': undefined, 'y': undefined}

    property string xAxisTitle: ''
    property string yAxisTitle: ''
    property color experimentLineColor: 'blue'
    property color calculatedLineColor: 'red'
    property color backgroundColor: 'white'
    property color foregroundColor: 'black'
    property int experimentLineWidth: 2
    property int calculatedLineWidth: 2

    color: backgroundColor

    WebEngineView {
        id: webView

        anchors.fill: parent
        anchors.margins: EaStyle.Sizes.fontPixelSize * 1.5
        backgroundColor: backgroundColor
    }

    property string html:
        EaLogic.Plotting.bokehHtml(
            // data
            {
                measured: measuredData,
                calculated: calculatedData
            },
            // specs
            {
                chartWidth: container.width - webView.anchors.margins * 2,
                chartHeight: container.height - webView.anchors.margins * 2,
                chartBackgroundColor: backgroundColor,
                xAxisTitle: xAxisTitle,
                yAxisTitle: yAxisTitle,
                experimentLineColor: experimentLineColor,
                calculatedLineColor: calculatedLineColor,
                experimentLineWidth: experimentLineWidth,
                calculatedLineWidth: calculatedLineWidth
            }
            )

    onHtmlChanged: webView.loadHtml(html)
}
