import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property string cifStr: ''
    property string chartForegroundColor: 'black'

    color: 'white'

    WebEngineView {
        id: webView

        anchors.fill: parent
        anchors.margins: EaStyle.Sizes.fontPixelSize * 1.5
        backgroundColor: container.color
    }

    property string html: EaLogic.Plotting.chemDoodleHtml({
        cifStr: cifStr,
        chartWidth: container.width.toString(),
        chartHeight: container.height.toString(),
        chartBackgroundColor: container.color,
        chartForegroundColor: chartForegroundColor
    })

    onHtmlChanged: webView.loadHtml(html)
}
