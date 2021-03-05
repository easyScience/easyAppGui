// Common

function headCommon() {
    const list = [
              '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>',
              '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=PT+Sans:400">'
          ]
    return list.join('\n')
}

function charthHtml(head, chart) {
    const list = [
              '<!DOCTYPE html>',
              '<html>',
              '<head>',
              head,
              '</head>',
              '<body>',
              '<script>',
              chart,
              '</script>',
              '</body>',
              '</html>'
          ]
    return list.join('\n')
}

// ChemDoodle

function chemDoodleInfo() {
    return {
        version: '9.1.0',
        url: 'https://web.chemdoodle.com'
    }
}

function chemDoodleHtml(cifStr, specs) {
    const head = chemDoodleHead()
    const chart = chemDoodleChart(cifStr, specs)
    const html = charthHtml(head, chart)
    return html
}

function chemDoodleHeadScripts() {
    const baseSrc = 'http://easyscience.apptimity.com/easyDiffraction/libs'
    const version = chemDoodleInfo().version
    const list = [
              `<script type="text/javascript" src="${baseSrc}/ChemDoodleWeb-${version}.js"></script>`
          ]
    return list.join('\n')
}

function chemDoodleHeadStyle() {
    const list = [
              '<style type="text/css">',
              '* { ',
              '    margin: 0;',
              '    padding: 0;',
              '    box-sizing: border-box;',
              '}',
              'body {',
              '    overflow: hidden;',
              '    font-family: "PT Sans", sans-serif;',
              '}',
              '</style>'
          ]
    return list.join('\n')
}

function chemDoodleHead() {
    const list = [
            headCommon(),
            chemDoodleHeadScripts(),
            chemDoodleHeadStyle()
          ]
    return list.join('\n')
}

function chemDoodleChart(cifStr, specs) {
    const list = [
              'const cifStr = '+cifStr,
              'const xSuper = 1',
              'const ySuper = 1',
              'const zSuper = 1',
              'const phase = ChemDoodle.readCIF(cifStr, xSuper, ySuper, zSuper)',
              `const crystalTransformer = new ChemDoodle.TransformCanvas3D("crystalTransformer", ${specs.chartWidth}, ${specs.chartHeight})`,
              'crystalTransformer.styles.set3DRepresentation("Ball and Stick")',
              'crystalTransformer.styles.projectionPerspective_3D = true',
              'crystalTransformer.styles.projectionPerspectiveVerticalFieldOfView_3D = 20',
              'crystalTransformer.styles.bonds_display = true',
              'crystalTransformer.styles.bonds_splitColor = true',
              'crystalTransformer.styles.atoms_displayLabels_3D = true',
              'crystalTransformer.styles.compass_display = true',
              'crystalTransformer.styles.compass_type_3D = 0',
              'crystalTransformer.styles.compass_size_3D = 70',
              'crystalTransformer.styles.compass_displayText_3D = true',
              `crystalTransformer.styles.shapes_color = "${specs.chartForegroundColor}"`,
              'crystalTransformer.styles.text_font_size = 12',
              'crystalTransformer.styles.text_font_families = ["PT Sans", "Helvetica", "Arial", "Dialog"]',
              `crystalTransformer.styles.backgroundColor = "${specs.chartBackgroundColor}"`,
              'crystalTransformer.loadContent([phase.molecule],[phase.unitCell])'
          ]
    return list.join('\n')
}

// Bokeh

function bokehInfo() {
    const version = '2.2.3'
    return {
        version: version,
        url: `https://docs.bokeh.org/en/${version}`
    }
}

function bokehHtml(data, specs) {
    const head = bokehHead()
    const chart = bokehChart(data, specs)
    const html = charthHtml(head, chart)
    return html
}

function bokehHeadScripts() {
    const baseSrc = 'https://cdn.pydata.org/bokeh/release'
    const version = bokehInfo().version
    const list = [
              `<script type="text/javascript" src="${baseSrc}/bokeh-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-widgets-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-tables-${version}.min.js"></script>`,
              `<script type="text/javascript" src="${baseSrc}/bokeh-api-${version}.min.js"></script>`
          ]
    return list.join('\n')
}

function bokehHeadStyle() {
    const list = [
              '<style type="text/css">',
              '* { ',
              '    margin: 0;',
              '    padding: 0;',
              '    box-sizing: border-box;',
              '}',
              'body {',
              '    overflow: hidden;',
              '    font-family: "PT Sans", sans-serif;',
              '}',
              '.bk-logo {',
              '    display: none !important;',
              '}',
              '</style>'
          ]
    return list.join('\n')
}

function bokehHead() {
    const list = [
            headCommon(),
            bokehHeadScripts(),
            bokehHeadStyle()
          ]
    return list.join('\n')
}

function bokehChart(data, specs) {
    if (!data.hasMeasured && !data.hasCalculated && !data.hasPlotRanges) {
        return
    }

    // X-axis font size in px
    let mainChartXAxisFontSizePx = 0
    let braggChartXAxisFontSizePx = 0
    let differenceChartXAxisFontSizePx = 0
    if (data.hasDifference) {
        differenceChartXAxisFontSizePx = specs.fontPixelSize
    } else if (data.hasBragg) {
        braggChartXAxisFontSizePx = specs.fontPixelSize
    } else {
        mainChartXAxisFontSizePx = specs.fontPixelSize
    }

    // List of strings to be filled below
    let chart = []

    // Tooltips
    chart.push(addMainTooltip(data, specs))
    chart.push(addBraggTooltip(specs))

    // Data source
    chart.push('const source = new Bokeh.ColumnDataSource()')

    // Charts array
    chart.push('const charts = []')

    // Main chart (top)
    chart.push(...createMainChart(data, specs))
    chart.push(...addMainTools('main_chart'))
    chart.push(...addVisibleXAxis('main_chart', specs, mainChartXAxisFontSizePx))
    chart.push(...addVisibleYAxis('main_chart', specs))
    if (data.hasMeasured) {
        chart.push(...addMeasuredDataToMainChart(data, specs))
    }
    if (data.hasCalculated) {
        chart.push(...addCalculatedDataToMainChart(data, specs))
    }
    chart.push(`charts.push([main_chart])`)

    // Bragg peaks chart (middle)
    if (data.hasBragg) {
        chart.push(...createBraggChart(data, specs))
        chart.push(...addBraggTools())
        chart.push(...addVisibleXAxis('bragg_chart', specs, braggChartXAxisFontSizePx))
        chart.push(...addHiddenYAxis('bragg_chart'))
        chart.push(`bragg_chart.min_border_top = Math.max(${braggChartXAxisFontSizePx}, ${differenceChartXAxisFontSizePx})`)
        chart.push(...addDataToBraggChart(data, specs))
        chart.push(`charts.push([bragg_chart])`)
    }

    // Difference chart (bottom)
    if (data.hasDifference) {
        chart.push(...createDiffChart(data, specs))
        chart.push(...addMainTools('diff_chart'))
        chart.push(...addVisibleXAxis('diff_chart', specs, differenceChartXAxisFontSizePx))
        chart.push(...addVisibleYAxis('diff_chart', specs))
        chart.push(`diff_chart.ygrid[0].ticker.desired_num_ticks = 3`)
        chart.push(`diff_chart.min_border_top = ${differenceChartXAxisFontSizePx}`)
        chart.push(...addDataToDiffChart(data, specs))
        chart.push(`charts.push([diff_chart])`)
    }

    // Charts array grid layout
    chart.push(`const gridplot = new Bokeh.Plotting.gridplot(charts)`)

    // Show charts
    if (typeof specs.containerId !== 'undefined') {
        chart.push(`Bokeh.Plotting.show(gridplot, "#${specs.containerId}")`)
    } else {
        chart.push(`Bokeh.Plotting.show(gridplot)`)
    }

    // Return as string
    return chart.join('\n')
}

function createMainChart(data, specs) {
    return [`const main_chart = new Bokeh.Plotting.figure({`,
            `   tools: "reset",`,

            `   height: ${specs.mainChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: new Bokeh.Range1d({`,
            `       start: ${data.ranges.min_x},`,
            `       end: ${data.ranges.max_x}`,
            `   }),`,
            `   y_range: new Bokeh.Range1d({`,
            `       start: ${data.ranges.min_y},`,
            `       end: ${data.ranges.max_y}`,
            `   }),`,

            `   x_axis_label: "${specs.xAxisTitle}",`,
            `   y_axis_label: "${specs.yMainAxisTitle}",`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}"`,
            `})`,

            `main_chart.min_border = 0`]
}

function createBraggChart(data, specs) {
    return [`const bragg_chart = new Bokeh.Plotting.figure({`,
            `   tools: "",`,

            `   height: ${specs.braggChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: main_chart.x_range,`,
            `   y_range: new Bokeh.Range1d({ start: -1, end: 1 }),`,

            `   x_axis_label: "${specs.xAxisTitle}",`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}"`,
            `})`,

            `bragg_chart.min_border = 0`]
}

function createDiffChart(data, specs) {
    const ratio = 0.5 * (specs.differenceChartHeight - 3 * specs.fontPixelSize) / (specs.mainChartHeight + 30)
    return [`const diff_chart = new Bokeh.Plotting.figure({`,
            `   tools: "reset",`,

            `   height: ${specs.differenceChartHeight},`,
            `   width: ${specs.chartWidth},`,

            `   x_range: main_chart.x_range,`,
            `   y_range: new Bokeh.Range1d({`,
            `       start: ${data.difference.median_y} - (main_chart.y_range.start - main_chart.y_range.end) * ${ratio},`,
            `       end: ${data.difference.median_y} + (main_chart.y_range.start - main_chart.y_range.end) * ${ratio}`,
            `   }),`,

            `   x_axis_label: "${specs.xAxisTitle}",`,
            `   y_axis_label: "${specs.yDifferenceAxisTitle}",`,

            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}"`,
            `})`,

            `diff_chart.min_border = 0`]
}

function addMeasuredDataToMainChart(data, specs) {
    return [`source.data.x_meas = [${data.measured.x}]`,
            `source.data.y_meas = [${data.measured.y}]`,
            `source.data.sy_meas = [${data.measured.sy}]`,
            `source.data.y_meas_upper = [${data.measured.y_upper}]`,
            `source.data.y_meas_lower = [${data.measured.y_lower}]`,

            `const measLineTop = new Bokeh.Line({`,
            `    x: { field: "x_meas" },`,
            `    y: { field: "y_meas_upper" },`,
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.measuredLineWidth}`,
            `})`,
            `const measLineBottom = new Bokeh.Line({`,
            `    x: { field: "x_meas" },`,
            `    y: { field: "y_meas_lower" },`,
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.measuredLineWidth}`,
            `})`,
            `const measArea = new Bokeh.VArea({`,
            `    x: { field: "x_meas" },`,
            `    y1: { field: "y_meas_upper" },`,
            `    y2: { field: "y_meas_lower" },`,
            `    fill_color: "${specs.measuredAreaColor}",`,
            `    fill_alpha: 0.33`,
            `})`,

            `main_chart.add_glyph(measArea, source)`,
            `main_chart.add_glyph(measLineTop, source)`,
            `main_chart.add_glyph(measLineBottom, source)`]
}

function addCalculatedDataToMainChart(data, specs) {
    return [`source.data.x_calc = [${data.calculated.x}]`,
            `source.data.y_calc = [${data.calculated.y}]`,

            'const calcLine = new Bokeh.Line({',
            '    x: { field: "x_calc" },',
            '    y: { field: "y_calc" },',
            `    line_color: "${specs.calculatedLineColor}",`,
            `    line_width: ${specs.calculatedLineWidth}`,
            '})',

            'main_chart.add_glyph(calcLine, source)']
}

function addDataToBraggChart(data, specs) {
    return [`source.data.x_bragg = [${data.bragg.x}]`,
            `source.data.y_bragg = [${data.bragg.y}]`,

            `const braggTicks = new Bokeh.Scatter({`,
            `   x: { field: "x_bragg" },`,
            `   y: { field: "y_bragg" },`,
            `   marker: "dash",`,
            `   size: ${specs.fontPixelSize * 1.5},`,
            `   line_color: "${specs.braggTicksColor}",`,
            `   angle: ${Math.PI / 2.}`,
            `})`,

            `bragg_chart.add_glyph(braggTicks, source)`]
}

function addDataToDiffChart(data, specs) {
    return [`source.data.x_diff = [${data.difference.x}]`,
            `source.data.y_diff = [${data.difference.y}]`,
            `source.data.y_diff_upper = [${data.difference.y_upper}]`,
            `source.data.y_diff_lower = [${data.difference.y_lower}]`,

            `const diffLineTop = new Bokeh.Line({`,
            `    x: { field: "x_diff" },`,
            `    y: { field: "y_diff_upper" },`,
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.differenceLineWidth}`,
            `})`,
            `const diffLineBottom = new Bokeh.Line({`,
            `    x: { field: "x_diff" },`,
            `    y: { field: "y_diff_lower" },`,
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.differenceLineWidth}`,
            `})`,
            `const diffArea = new Bokeh.VArea({`,
            `    x: { field: "x_diff" },`,
            `    y1: { field: "y_diff_upper" },`,
            `    y2: { field: "y_diff_lower" },`,
            `    fill_color: "${specs.differenceAreaColor}",`,
            `    fill_alpha: 0.33`,
            `})`,

            `diff_chart.add_glyph(diffArea, source)`,
            `diff_chart.add_glyph(diffLineTop, source)`,
            `diff_chart.add_glyph(diffLineBottom, source)`]
}

function addMainTools(chart) {
    return [`${chart}.add_tools(new Bokeh.HoverTool({tooltips:main_tooltip, point_policy:"snap_to_data", mode:"mouse"}))`,
            `${chart}.add_tools(new Bokeh.BoxZoomTool())`,
            `${chart}.toolbar.active_drag = "box_zoom"`,
            `${chart}.add_tools(new Bokeh.PanTool())`]
}

function addBraggTools() {
    return [`bragg_chart.add_tools(new Bokeh.HoverTool({tooltips:bragg_tooltip, point_policy:"snap_to_data", mode:"mouse"}))`]
}

function mainTooltipRow(color, label, value, sigma='') {
    return [`<tr style="color:${color}">`,
            `   <td style="text-align:right">${label}:&nbsp;</td>`,
            `   <td style="text-align:right">${value}</td>`,
            `   <td>${sigma}</td>`,
            `</tr>`]
}

function addMainTooltip(data, specs) {
    const x_meas = mainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_meas{0.00}')
    const x_calc = mainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_calc{0.00}')
    const y_meas = mainTooltipRow(specs.measuredLineColor, 'meas', '@y_meas{0.0}', '&#177;&nbsp;@sy_meas{0.0}')
    const y_calc = mainTooltipRow(specs.calculatedLineColor, 'calc', '@y_calc{0.0}')
    const y_diff = mainTooltipRow(specs.differenceLineColor, 'diff', '@y_diff{0.0}')

    let table = []
    table.push(...[`<table>`, `<tbody>`])
    // x
    if (data.hasMeasured) {
        table.push(...x_meas)
    } else if (data.hasCalculated) {
        table.push(...x_calc)
    }
    // y
    if (data.hasMeasured) {
        table.push(...y_meas)
    }
    if (data.hasCalculated) {
        table.push(...y_calc)
    }
    if (data.hasDifference) {
        table.push(...y_diff)
    }
    table.push(...[`</tbody>`, `</table>`])

    const tooltip = JSON.stringify(table.join('\n'))
    return `const main_tooltip = (${tooltip})`
}

function addBraggTooltip(specs) {
    const x_bragg = mainTooltipRow(EaStyle.Colors.themeForegroundDisabled, 'x', '@x_bragg{0.00}')
    const y_bragg = mainTooltipRow(specs.calculatedLineColor, 'hkl', '@y_bragg{0.00}')

    let table = []
    table.push(...[`<table>`, `<tbody>`])
    table.push(...x_bragg)
    table.push(...y_bragg)
    table.push(...[`</tbody>`, `</table>`])

    const tooltip = JSON.stringify(table.join('\n'))
    return `const bragg_tooltip = (${tooltip})`
}

function addVisibleXAxis(chart, specs, xAxisFontSizePx) {
    return [`${chart}.xaxis[0].axis_label_text_font = "PT Sans"`,
            `${chart}.xaxis[0].axis_label_text_font_style = "normal"`,
            `${chart}.xaxis[0].axis_label_text_font_size = "${xAxisFontSizePx}px"`,
            `${chart}.xaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.xaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,
            `${chart}.xaxis[0].axis_line_color = null`,

            `${chart}.xaxis[0].major_label_text_font = "PT Sans"`,
            `${chart}.xaxis[0].major_label_text_font_size = "${xAxisFontSizePx}px"`,
            `${chart}.xaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.xaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `${chart}.xaxis[0].major_tick_in = 0`,
            `${chart}.xaxis[0].major_tick_out = 0`,
            `${chart}.xaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `${chart}.xaxis[0].minor_tick_out = 0`,

            `${chart}.xgrid[0].grid_line_color = "${specs.chartGridLineColor}"`]
}

function addVisibleYAxis(chart, specs) {
    return [`${chart}.yaxis[0].axis_label_text_font = "PT Sans"`,
            `${chart}.yaxis[0].axis_label_text_font_style = "normal"`,
            `${chart}.yaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.yaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.yaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,
            `${chart}.yaxis[0].axis_line_color = null`,

            `${chart}.yaxis[0].major_label_text_font = "PT Sans"`,
            `${chart}.yaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `${chart}.yaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `${chart}.yaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `${chart}.yaxis[0].major_tick_in = 0`,
            `${chart}.yaxis[0].major_tick_out = 0`,
            `${chart}.yaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `${chart}.yaxis[0].minor_tick_out = 0`,

            `${chart}.ygrid[0].grid_line_color = "${specs.chartGridLineColor}"`]
}

function addHiddenYAxis(chart) {
    return [`${chart}.yaxis[0].axis_line_color = null`,

            `${chart}.yaxis[0].major_tick_in = 0`,
            `${chart}.yaxis[0].major_tick_out = 0`,
            `${chart}.yaxis[0].minor_tick_out = 0`,
            `${chart}.yaxis[0].major_label_text_font_size = "0px"`,

            `${chart}.ygrid[0].grid_line_color = null`]
}
