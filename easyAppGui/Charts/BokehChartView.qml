import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property var measuredData: ({})
    property var calculatedData: ({})
    property var differenceData: ({})
    property var braggData: ({})
    property var plotRanges: ({})

    property bool hasMeasuredData: typeof measuredData !== 'undefined'
                                   && typeof measuredData.x !== 'undefined'
                                   && measuredData.x.length
    property bool hasCalculatedData: typeof calculatedData !== 'undefined'
                                     && typeof calculatedData.x !== 'undefined'
                                     && calculatedData.x.length
    property bool hasDifferenceData: typeof differenceData !== 'undefined'
                                     && typeof differenceData.x !== 'undefined'
                                     && differenceData.x.length
    property bool hasBraggData: typeof braggData !== 'undefined'
                                && typeof braggData.x !== 'undefined'
                                && braggData.x.length
    property bool hasPlotRangesData: typeof plotRanges !== 'undefined'

    property int chartWidth: container.width - webView.anchors.margins * 2
    property int mainChartHeight: container.height
                                  - webView.anchors.margins * 2
                                  - braggChartHeight
                                  - differenceChartHeight
                                  - 30 // chart button size in px
    property int braggChartHeight: hasBraggData
                                   ? EaStyle.Sizes.fontPixelSize * (7 - 4 * +(differenceChartHeight>0))
                                   : 0
    property int differenceChartHeight: hasDifferenceData
                                        ? EaStyle.Sizes.fontPixelSize * 12
                                        : 0

    property string xAxisTitle: ''
    property string yMainAxisTitle: ''
    property string yDifferenceAxisTitle: ''

    property color chartBackgroundColor: EaStyle.Colors.chartPlotAreaBackground
    property color chartForegroundColor: EaStyle.Colors.chartForeground
    property color chartGridLineColor: EaStyle.Colors.chartGridLine
    property color chartMinorGridLineColor: EaStyle.Colors.chartMinorGridLine

    property color measuredLineColor: EaStyle.Colors.chartForegrounds[0]
    property color measuredAreaColor: measuredLineColor
    property color calculatedLineColor: EaStyle.Colors.chartForegrounds[1]
    property color braggTicksColor: calculatedLineColor
    property color differenceLineColor: EaStyle.Colors.chartForegrounds[2]
    property color differenceAreaColor: differenceLineColor

    property int measuredLineWidth: 1
    property int calculatedLineWidth: 2
    property int differenceLineWidth: 1

    property int fontPixelSize: EaStyle.Sizes.fontPixelSize

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
        webView.loadHtml(html)
    }

    color: chartBackgroundColor

    WebEngineView {
        id: webView

        anchors.fill: parent
        anchors.margins: EaStyle.Sizes.fontPixelSize * 1.5
        backgroundColor: backgroundColor
    }

}
