import QtQuick 2.13
import QtWebEngine 1.10

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property bool showMeasured: false
    property bool showCalculated: false
    property bool showBragg: false
    property bool showDifference: false

    property var measuredData: {'x': undefined, 'y': undefined}
    property var calculatedData: {'x': undefined, 'y': undefined}
    property var braggData: {'x': undefined, 'y': undefined}
    property var differenceData: {'x': undefined, 'y': undefined}

    property bool hasMeasuredData: typeof measuredData !== 'undefined'
                                   && typeof measuredData.x !== 'undefined'
    property bool hasCalculatedData: typeof calculatedData !== 'undefined'
                                     && typeof calculatedData.x !== 'undefined'
    property bool hasBraggData: typeof braggData !== 'undefined'
                                && typeof braggData.x !== 'undefined'
    property bool hasDifferenceData: typeof differenceData !== 'undefined'
                                     && typeof differenceData.x !== 'undefined'

    property var plotRanges: ({})

    property int chartWidth: container.width - webView.anchors.margins * 2
    property int mainChartHeight: container.height
                                  - webView.anchors.margins * 2
                                  - braggChartHeight
                                  - differenceChartHeight
                                  - 30
    property int braggChartHeight: showBragg && hasBraggData
                                   ? 25
                                   : 0
    property int differenceChartHeight: showDifference && hasDifferenceData
                                        ? 150
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

    color: chartBackgroundColor

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
                calculated: calculatedData,
                bragg: braggData,
                difference: differenceData,
                ranges: plotRanges
            },
            // specs
            {
                showMeasured: showMeasured,
                showCalculated: showCalculated,
                showBragg: showBragg,
                showDifference: showDifference,

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
        print("+++++++++++++++++++", html)
        webView.loadHtml(html)
    }
}
