import QtQuick 2.13
import QtCharts 2.13

import easyAppGui.Style 1.0 as EaStyle

import Gui.Globals 1.0 as ExGlobals

ScatterSeries {
    id: series

    property var customPoints: [] //[Qt.point(0, -1), Qt.point(10, 6)] //[{"x":0,"y":-1},{"x":10,"y":6}]

    color: EaStyle.Colors.chartLine

    onCustomPointsChanged: customReplacePoints()

    Component.onCompleted: customAppend()

    // Python-based logic

    function customAppend() {
        ExGlobals.Constants.proxy.plotting1d.lineSeriesCustomReplace(series, customPoints)
    }

    function customReplacePoints() {
        ExGlobals.Constants.proxy.plotting1d.lineSeriesCustomReplace(series, customPoints)
    }
}
