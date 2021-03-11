import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property bool showBonds: true
    property color backgroundColor: 'white'
    property color foregroundColor: 'black'
    color: backgroundColor

    property string cifStr: ''

    property var chartSpecs: {
        'showBonds': showBonds ? true : false,

        'chartWidth': container.width.toString(),
        'chartHeight': container.height.toString(),
        'chartBackgroundColor': backgroundColor,
        'chartForegroundColor': foregroundColor
    }

    property string html: EaLogic.Plotting.chemDoodleHtml(cifStr, chartSpecs)

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.margins: 0
        backgroundColor: backgroundColor
    }

    onHtmlChanged: {
        //print(html)
        chartView.loadHtml(html)
    }
}
