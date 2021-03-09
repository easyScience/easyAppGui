import QtQuick 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Logic 1.0 as EaLogic

Rectangle {
    id: container

    property int chartToolButtonsHeight: 30
    property int paddings: EaStyle.Sizes.fontPixelSize

    property var measuredData: ({})
    property var calculatedData: ({})
    property var differenceData: ({})
    property var braggData: ({})
    property var plotRanges: ({})

    property bool hasMeasuredData: typeof measuredData !== 'undefined' &&
                                   ((typeof measuredData.x !== 'undefined' && measuredData.x.length) ||
                                    (typeof measuredData.xy_upper !== 'undefined' && measuredData.xy_upper.length))
    property bool hasCalculatedData: typeof calculatedData !== 'undefined' &&
                                     ((typeof calculatedData.x !== 'undefined' && calculatedData.x.length) ||
                                      (typeof calculatedData.xy !== 'undefined' && calculatedData.xy.length))
    property bool hasDifferenceData: typeof differenceData !== 'undefined' &&
                                     ((typeof differenceData.x !== 'undefined' && differenceData.x.length) ||
                                      (typeof differenceData.xy_upper !== 'undefined' && differenceData.xy_upper.length))
    property bool hasBraggData: typeof braggData !== 'undefined' &&
                                ((typeof braggData.x !== 'undefined' && braggData.x.length) ||
                                 (typeof braggData.xy !== 'undefined' && braggData.xy.length))
    property bool hasPlotRangesData: typeof plotRanges !== 'undefined'

    property int chartWidth: container.width - paddings * 2
    property int mainChartHeight: container.height
                                  - paddings * 2
                                  - braggChartHeight
                                  - differenceChartHeight
                                  - chartToolButtonsHeight
    property int braggChartHeight: hasBraggData
                                   ? EaStyle.Sizes.fontPixelSize * (7.5 - 2 * hasDifferenceData)
                                   : 0
    property int differenceChartHeight: hasDifferenceData
                                        ? EaStyle.Sizes.fontPixelSize * 10
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
}
