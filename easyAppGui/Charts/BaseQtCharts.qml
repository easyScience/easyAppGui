import QtQuick 2.13
import QtCharts 2.13

import QtQuick.Controls 2.13

import easyAppGui.Style 1.0 as EaStyle
import easyAppGui.Elements 1.0 as EaElements
import easyAppGui.Charts 1.0 as EaCharts

import Gui.Globals 1.0 as ExGlobals

EaCharts.BasePlot {
    property int chartExtraMargin: -12
    property int chartVMargin: chartExtraMargin
    property int chartHMargin: chartExtraMargin + 0.5 * fontPixelSize

    Column {
        anchors.centerIn: parent
        spacing: 0

        ///////////////////////////
        // Chart tool buttons space
        ///////////////////////////

        Item {
            width: 1
            height: chartToolButtonsHeight
        }

        /////////////
        // Main chart
        /////////////

        Item {
            width: chartWidth
            height: mainChartHeight

            EaCharts.ChartView {
                id: mainChart

                property bool allowHover: true

                anchors.fill: parent
                anchors.topMargin: chartVMargin
                anchors.bottomMargin: chartVMargin
                anchors.leftMargin: chartHMargin
                anchors.rightMargin: chartHMargin

                backgroundColor: 'transparent' //'#250000ff'

                EaCharts.ValueAxis {
                    id: mainAxisX

                    title: xAxisTitle

                    titleVisible: !hasBraggData && !hasDifferenceData
                    labelsVisible: !hasBraggData && !hasDifferenceData

                    min: plotRanges.min_x
                    max: plotRanges.max_x
                }

                EaCharts.ValueAxis {
                    id: mainAxisY

                    title: yMainAxisTitle

                    min: plotRanges.min_y
                    max: plotRanges.max_y

                    onRangeChanged: {
                        adjustDifferenceChartRangeY()
                        adjustLeftAxesAnchor()
                    }
                }

                // Measured data
                EaCharts.AreaSeries {
                    color: measuredLineColor

                    axisX: mainAxisX
                    axisY: mainAxisY

                    lowerSeries: EaCharts.LineSeries {
                        customPoints: measuredData.xy_lower
                    }

                    upperSeries: EaCharts.LineSeries {
                        customPoints: measuredData.xy_upper
                    }
                }

                // Calculated curve
                EaCharts.LineSeries {
                    color: calculatedLineColor

                    axisX: mainAxisX
                    axisY: mainAxisY

                    customPoints: calculatedData.xy
                }

                // Hidden measured points for tooltips
                EaCharts.ScatterSeries {
                    axisX: mainAxisX
                    axisY: mainAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: fontPixelSize * 2
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: measuredData.xy

                    onHovered: showMainTooltip(mainChart, 'y_meas', point, state)
                }

                // Hidden calculated points for tooltips
                EaCharts.ScatterSeries {
                    axisX: mainAxisX
                    axisY: mainAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: fontPixelSize * 2
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: calculatedData.xy

                    onHovered: showMainTooltip(mainChart, 'y_calc', point, state)
                }

                /*
                onPlotAreaChanged: {
                    adjustDifferenceChartRangeY()
                    adjustLeftAxesAnchor()
                }
                */
            }

            /////////////////////
            // Chart tool buttons
            /////////////////////

            Row {
                x: mainChart.plotArea.x + mainChart.plotArea.width - childrenRect.width - 4
                y: -childrenRect.height + fontPixelSize - 3

                EaElements.TabButton {
                    checked: mainChart.allowZoom
                    autoExclusive: false
                    height: chartToolButtonsHeight
                    width: chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartGridLine
                    fontIcon: "expand"
                    ToolTip.text: qsTr("Box zoom")
                    onClicked: mainChart.allowZoom = !mainChart.allowZoom
                }

                EaElements.TabButton {
                    checkable: false
                    height: chartToolButtonsHeight
                    width: chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartGridLine
                    fontIcon: "sync-alt"
                    ToolTip.text: qsTr("Reset")
                    onClicked: mainChart.zoomReset()
                }

                EaElements.TabButton {
                    checked: mainChart.allowHover
                    autoExclusive: false
                    height: chartToolButtonsHeight
                    width: chartToolButtonsHeight
                    borderColor: EaStyle.Colors.chartGridLine
                    fontIcon: "comment-alt"
                    ToolTip.text: qsTr("Hover")
                    onClicked: mainChart.allowHover = !mainChart.allowHover
                }
            }
        }

        /////////////////
        // Main chart end
        /////////////////

        //////////////
        // Bragg chart
        //////////////

        Item {
            visible: hasBraggData

            width: chartWidth
            height: braggChartHeight

            EaCharts.ChartView {
                id: braggChart

                anchors.fill: parent
                anchors.topMargin: chartVMargin - fontPixelSize * 1.5
                anchors.bottomMargin: chartVMargin
                anchors.leftMargin: chartHMargin
                anchors.rightMargin: chartHMargin

                allowZoom: false

                backgroundColor: 'transparent' //'#2500ff00'

                EaCharts.ValueAxis {
                    id: braggAxisX

                    title: xAxisTitle

                    titleVisible: hasBraggData && !hasDifferenceData
                    labelsVisible: hasBraggData && !hasDifferenceData

                    min: mainAxisX.min
                    max: mainAxisX.max
                }

                EaCharts.ValueAxis {
                    id: braggAxisY

                    titleVisible: false
                    labelsVisible: false

                    tickCount: 2

                    min: -1
                    max: 1
                }

                EaCharts.ScatterSeries {
                    axisX: braggAxisX
                    axisY: braggAxisY

                    markerShape: ScatterSeries.MarkerShapeRectangle
                    markerSize: fontPixelSize * 2
                    brush: ExGlobals.Constants.proxy.qtCharts.brush(markerSize, calculatedLineColor)

                    customPoints: braggData.xy

                    onHovered: {
                        if (!mainChart.allowHover) {
                            return
                        }
                        const p = braggChart.mapToPosition(point)
                        const text = qsTr("x: %1<br>hkl: %2").arg(point.x).arg(point.y)
                        braggInfoToolTip.parent = braggChart
                        braggInfoToolTip.visible = state
                        braggInfoToolTip.x = p.x
                        braggInfoToolTip.y = p.y - braggInfoToolTip.height
                        braggInfoToolTip.text = text
                    }
                }
            }
        }

        //////////////////
        // Bragg chart end
        //////////////////

        ///////////////////
        // Difference chart
        ///////////////////

        Item {
            visible: hasDifferenceData
            z: 10

            width: chartWidth
            height: differenceChartHeight

            EaCharts.ChartView {
                id: differenceChart

                backgroundColor: 'transparent' //'#25ff0000'

                anchors.fill: parent
                anchors.topMargin: chartVMargin - fontPixelSize * 1.5
                anchors.bottomMargin: chartVMargin
                anchors.leftMargin: chartHMargin
                anchors.rightMargin: chartHMargin

                allowZoom: false

                EaCharts.ValueAxis {
                    id: differenceAxisX

                    title: xAxisTitle

                    titleVisible: hasDifferenceData
                    labelsVisible: hasDifferenceData

                    min: mainAxisX.min
                    max: mainAxisX.max
                }

                EaCharts.ValueAxis {
                    id: differenceAxisY

                    title: yDifferenceAxisTitle

                    tickType: ValueAxis.TicksFixed
                    tickCount: 3
                }

                // Difference area
                EaCharts.AreaSeries {
                    color: differenceLineColor

                    axisX: differenceAxisX
                    axisY: differenceAxisY

                    lowerSeries: EaCharts.LineSeries {
                        customPoints: differenceData.xy_lower
                    }

                    upperSeries: EaCharts.LineSeries {
                        customPoints: differenceData.xy_upper
                    }
                }

                // Hidden difference points for tooltips
                EaCharts.ScatterSeries {
                    axisX: differenceAxisX
                    axisY: differenceAxisY

                    markerShape: ScatterSeries.MarkerShapeCircle
                    markerSize: fontPixelSize * 2
                    color: "transparent"
                    borderColor: "transparent"

                    customPoints: differenceData.xy

                    onHovered: showMainTooltip(differenceChart, 'y_diff', point, state)
                }
            }
        }

        ///////////////////////
        // Difference chart end
        ///////////////////////

        EaElements.ToolTip {
            id: mainInfoToolTip
            backgroundColor: chartBackgroundColor
            borderColor: chartGridLineColor
        }

        EaElements.ToolTip {
            id: braggInfoToolTip
            backgroundColor: chartBackgroundColor
            borderColor: chartGridLineColor
        }

    }

    // Logic

    function mainToolTipData(point) {
        let xy = []
        if (hasMeasuredData) {
            xy = measuredData.xy
        } else if (hasCalculatedData) {
            xy = calculatedData.xy
        } else {
            return null
        }
        let data = {}
        for (let i in xy) {
            if (Math.abs(point.x - xy[i].x) <= 0.01) {
                data.x = xy[i].x
                if (hasMeasuredData) {
                    data.y_meas = measuredData.xy[i].y
                    data.sy_meas = measuredData.xy_upper[i].y - measuredData.xy[i].y
                }
                if (hasCalculatedData) {
                    data.y_calc = calculatedData.xy[i].y
                }
                if (hasDifferenceData) {
                    data.y_diff = differenceData.xy[i].y
                }
                return data
            }
        }
        return null
    }

    function showMainTooltip(chart, line, point, state) {
        if (!mainChart.allowHover) {
            return
        }
        mainInfoToolTip.parent = chart
        mainInfoToolTip.visible = state
        const data = mainToolTipData(point)
        if (data === null) {
            return
        }
        const pos = chart.mapToPosition(Qt.point(point.x, data[line]))
        mainInfoToolTip.x = pos.x
        mainInfoToolTip.y = pos.y - mainInfoToolTip.height
        mainInfoToolTip.text = mainTooltip(data)
    }

    function mainTooltipRow(color, label, value, sigma='') {
        return [`<tr style="color:${color}">`,
                `   <td style="text-align:right">${label}:&nbsp;</td>`,
                `   <td style="text-align:right">${value}</td>`,
                `   <td>${sigma}</td>`,
                `</tr>`]
    }

    function mainTooltip(data) {
        let table = []
        table.push(...[`<table>`, `<tbody>`])

        const x = mainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', `${data.x.toFixed(2)}`)
        table.push(...x)
        if (hasMeasuredData) {
            const y_meas = mainTooltipRow(measuredLineColor, 'meas', `${data.y_meas.toFixed(1)}`, `&#177;&nbsp;${data.sy_meas.toFixed(1)}`)
            table.push(...y_meas)
        }
        if (hasCalculatedData) {
            const y_calc = mainTooltipRow(calculatedLineColor, 'calc', `${data.y_calc.toFixed(1)}`)
            table.push(...y_calc)
        }
        if (hasDifferenceData) {
            const y_diff = mainTooltipRow(differenceLineColor, 'diff', `${data.y_diff.toFixed(1)}`)
            table.push(...y_diff)
        }

        table.push(...[`</tbody>`, `</table>`])

        const tooltip = table.join('\n')
        return tooltip
    }

    function differenceChartMeanY() {
        let ySum = 0, yCount = 0
        for (let i in differenceData.xy) {
            if (differenceAxisX.min <= differenceData.xy[i].x && differenceData.xy[i].x <= differenceAxisX.max) {
                ySum += differenceData.xy[i].y
                yCount += 1
            }
        }
        if (yCount > 0) {
            return ySum / yCount
        }
        return 0
    }

    function differenceChartHalfRangeY() {
        const mainChartRangeY = mainAxisY.max - mainAxisY.min
        const differenceToMainChartHeightRatio = (differenceChartHeight - 2 * fontPixelSize) / ( mainChartHeight )
        const differenceChartRangeY = mainChartRangeY * differenceToMainChartHeightRatio
        return 0.5 * differenceChartRangeY
    }

    function adjustDifferenceChartRangeY() {
        differenceAxisY.min = differenceChartMeanY() - differenceChartHalfRangeY()
        differenceAxisY.max = differenceChartMeanY() + differenceChartHalfRangeY()
    }

    function adjustLeftAxesAnchor() {
        differenceChart.anchors.leftMargin = chartHMargin + (mainChart.plotArea.x - differenceChart.plotArea.x)
        braggChart.anchors.leftMargin = chartHMargin + (mainChart.plotArea.x - braggChart.plotArea.x)
    }

    function axisLabelFormat(range) {
        if (range < 1)
            return "%.2f"
        else if (range < 10)
            return "%.1f"
        else
            return "%.0f"
    }

}
