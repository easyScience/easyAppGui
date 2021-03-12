import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic
import easyAppGui.Charts 1.0 as EaCharts

EaCharts.BasePlot {
    id: plot

    property var chartData: {
        'measured': plot.measuredData,
        'calculated': plot.calculatedData,
        'difference': plot.differenceData,
        'bragg': plot.braggData,
        'background': plot.backgroundData,
        'ranges': plot.plotRanges,

        'hasMeasured': plot.hasMeasuredData,
        'hasCalculated': plot.hasCalculatedData,
        'hasDifference': plot.hasDifferenceData,
        'hasBragg': plot.hasBraggData,
        'hasBackground': plot.hasBackgroundData,
        'hasPlotRanges': plot.hasPlotRangesData
    }

    property var chartSpecs: {
        'chartWidth': plot.chartWidth,
        'mainChartHeight': plot.mainChartHeight,
        'braggChartHeight': plot.braggChartHeight,
        'differenceChartHeight': plot.differenceChartHeight,
        'xAxisChartHeight': plot.xAxisChartHeight,

        'xAxisTitle': plot.xAxisTitle,
        'yMainAxisTitle': plot.yMainAxisTitle,
        'yDifferenceAxisTitle': plot.yDifferenceAxisTitle,

        'chartBackgroundColor': plot.chartBackgroundColor,
        'chartForegroundColor': plot.chartForegroundColor,
        'chartGridLineColor': plot.chartGridLineColor,
        'chartMinorGridLineColor': plot.chartMinorGridLineColor,

        'measuredLineColor': plot.measuredLineColor,
        'measuredAreaColor': plot.measuredAreaColor,
        'calculatedLineColor': plot.calculatedLineColor,
        'differenceLineColor': plot.differenceLineColor,
        'braggTicksColor': plot.braggTicksColor,
        'backgroundLineColor': plot.backgroundLineColor,
        'differenceAreaColor': plot.differenceAreaColor,

        'measuredLineWidth': plot.measuredLineWidth,
        'calculatedLineWidth': plot.calculatedLineWidth,
        'differenceLineWidth': plot.differenceLineWidth,
        'backgroundLineWidth': plot.backgroundLineWidth,

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
