import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property string cifStr: ''

    property color backgroundColor: 'white'
    property color foregroundColor: 'black'

    color: backgroundColor

    WebEngineView {
        id: webView

        anchors.fill: parent
        anchors.margins: 0
        backgroundColor: backgroundColor
    }

    property string html:
        EaLogic.Plotting.chemDoodleHtml(
            // cif
            cifStr,
            // specs
            {
                chartWidth: container.width.toString(),
                chartHeight: container.height.toString(),
                chartBackgroundColor: backgroundColor,
                chartForegroundColor: foregroundColor
            }
            )

    onHtmlChanged: webView.loadHtml(html)
}
