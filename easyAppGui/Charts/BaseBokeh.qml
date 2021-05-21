import QtQuick 2.13
import QtQuick.Controls 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Logic 1.0 as EaLogic
import easyAppGui.Charts 1.0 as EaCharts

EaCharts.BasePlot {
    id: plot

    property var chartData: {
        'measured': plot.measuredData,
        'calculated': plot.calculatedData,
        'sld': plot.sldData,
        'ranges': plot.plotRanges,

        'hasMeasured': plot.hasMeasuredData,
        'hasCalculated': plot.hasCalculatedData,
        'hasSld': plot.hasSldData,
        'hasPlotRanges': plot.hasPlotRangesData
    }

    property var chartSpecs: {
        'chartWidth': plot.chartWidth,
        'mainChartHeight': plot.mainChartHeight,
        'sldChartHeight': plot.sldChartHeight,

        'xMainAxisTitle': plot.xMainAxisTitle,
        'yMainAxisTitle': plot.yMainAxisTitle,
        'xSldAxisTitle': plot.xSldAxisTitle,
        'ySldAxisTitle': plot.ySldAxisTitle,

        'chartBackgroundColor': plot.chartBackgroundColor,
        'chartForegroundColor': plot.chartForegroundColor,
        'chartGridLineColor': plot.chartGridLineColor,
        'chartMinorGridLineColor': plot.chartMinorGridLineColor,

        'measuredLineColor': plot.measuredLineColor,
        'measuredAreaColor': plot.measuredAreaColor,
        'calculatedLineColor': plot.calculatedLineColor,
        'sldLineColor': plot.sldLineColor,

        'measuredLineWidth': plot.measuredLineWidth,
        'calculatedLineWidth': plot.calculatedLineWidth,
        'sldLineWidth': plot.sldLineWidth,

        'fontPixelSize': plot.fontPixelSize
    }

    property string html: EaLogic.Plotting.bokehHtml(chartData, chartSpecs)

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.margins: plot.paddings
        anchors.topMargin: plot.paddings - 0.25 * plot.fontPixelSize
        backgroundColor: plot.chartBackgroundColor

        onContextMenuRequested: {
            request.accepted = true
        }
    }

    onHtmlChanged: {
        //print(html)
        chartView.loadHtml(html)
    }
}
