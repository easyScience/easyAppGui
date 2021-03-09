import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic
import easyAppGui.Charts 1.0 as EaCharts

EaCharts.BasePlot {

    WebEngineView {
        id: chartView

        anchors.fill: parent
        anchors.margins: paddings//EaStyle.Sizes.fontPixelSize * 1.5
        backgroundColor: backgroundColor
    }

    property string html:
        EaLogic.Plotting.bokehHtml(
            // data
            {
                measured: measuredData,
                calculated: calculatedData,
                difference: differenceData,
                bragg: braggData,
                ranges: plotRanges,

                hasMeasured: hasMeasuredData,
                hasCalculated: hasCalculatedData,
                hasBragg: hasBraggData,
                hasDifference: hasDifferenceData,
                hasPlotRanges: hasPlotRangesData
            },
            // specs
            {
                chartWidth: chartWidth,
                mainChartHeight: mainChartHeight,
                braggChartHeight: braggChartHeight,
                differenceChartHeight: differenceChartHeight,

                xAxisTitle: xAxisTitle,
                yMainAxisTitle: yMainAxisTitle,
                yDifferenceAxisTitle: yDifferenceAxisTitle,

                chartBackgroundColor: chartBackgroundColor,
                chartForegroundColor: chartForegroundColor,
                chartGridLineColor: chartGridLineColor,
                chartMinorGridLineColor: chartMinorGridLineColor,

                measuredLineColor: measuredLineColor,
                measuredAreaColor: measuredAreaColor,
                calculatedLineColor: calculatedLineColor,
                braggTicksColor: braggTicksColor,
                differenceLineColor: differenceLineColor,
                differenceAreaColor: differenceAreaColor,

                measuredLineWidth: measuredLineWidth,
                calculatedLineWidth: calculatedLineWidth,
                differenceLineWidth: differenceLineWidth,

                fontPixelSize: fontPixelSize
            }
            )

    onHtmlChanged: {
        //print(html)
        chartView.loadHtml(html)
    }

}
