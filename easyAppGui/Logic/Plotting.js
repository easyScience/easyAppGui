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
    const hasMeasuredData = typeof data.measured !== 'undefined'
                          && typeof data.measured.x !== 'undefined'
    const hasCalculatedData = typeof data.calculated !== 'undefined'
                          && typeof data.calculated.x !== 'undefined'
    const hasBraggData = typeof data.bragg !== 'undefined'
                       && typeof data.bragg.x !== 'undefined'
    const hasDifferenceData = typeof data.difference !== 'undefined'
                            && typeof data.difference.x !== 'undefined'

    //'plot.legend.label_text_font = "PT Sans"'

    // Chart tooltips
    let list = [
            'const main_tooltip = (',
            `   '<table><tbody>' +`
        ]
    if (hasMeasuredData && specs.showMeasured) {
        list.push(`   '<tr style="color:${EaStyle.Colors.themeForegroundDisabled}"><td style="text-align:right">x:&nbsp;</td><td style="text-align:right">@x_meas{0.00}</td></tr>' +`)
    } else if (hasCalculatedData && specs.showCalculated) {
        list.push(`   '<tr style="color:${EaStyle.Colors.themeForegroundDisabled}"><td style="text-align:right">x:&nbsp;</td><td style="text-align:right">@x_calc{0.00}</td></tr>' +`)
    }
    if (hasMeasuredData && specs.showMeasured) {
        list.push(`   '<tr style="color:${specs.measuredLineColor}"><td style="text-align:right">meas:&nbsp;</td><td style="text-align:right">@y_meas{0.0}</td></tr>' +`)
    }
    if (hasCalculatedData && specs.showCalculated) {
        list.push(`   '<tr style="color:${specs.calculatedLineColor}"><td style="text-align:right">calc:&nbsp;</td><td style="text-align:right">@y_calc{0.0}</td></tr>' +`)
    }
    if (hasDifferenceData  && specs.showDifference) {
        list.push(`   '<tr style="color:${specs.differenceLineColor}"><td style="text-align:right">diff:&nbsp;</td><td style="text-align:right">@y_diff{0.0}</td></tr>' +`)
    }
    list = list.concat([
            `   '</tbody></table>'`,
            ')',

            'const bragg_tooltip = (',
            `   '<table><tbody>' +`,
            `   '<tr style="color:${EaStyle.Colors.themeForegroundDisabled}"><td style="text-align:right">x:&nbsp;</td><td style="text-align:right">@x_bragg{0.00}</td></tr>' +`,
            `   '<tr style="color:${specs.braggLineColor}"><td style="text-align:right">hkl:&nbsp;</td><td style="text-align:right">@y_bragg{0.0}</td></tr>' +`,
            `   '</tbody></table>'`,
            ')'
        ])

    // Main chart (top): init
    list = list.concat([
            'const source = new Bokeh.ColumnDataSource()',

            'const charts = []',

            'const main_chart = new Bokeh.Plotting.figure({',
            '   tools: "reset",',
            `   height: ${specs.mainChartHeight},`,
            `   width: ${specs.chartWidth},`,
            `   x_range: new Bokeh.Range1d({`,
            `       start: Math.min(${data.measured.min_x}, ${data.calculated.min_x}),`,
            `       end: Math.max(${data.measured.max_x}, ${data.calculated.max_x})`,
            `   }),`,
            `   y_range: new Bokeh.Range1d({`,
            `       start: Math.min(${data.measured.min_y}, ${data.calculated.min_y}) - 0.1*Math.max(${data.measured.max_y}, ${data.calculated.max_y}),`,
            `       end: Math.max(${data.measured.max_y}, ${data.calculated.max_y}) + 0.1*Math.max(${data.measured.max_y}, ${data.calculated.max_y})`,
            `   }),`,
            `   x_axis_label: "${specs.xAxisTitle}",`,
            `   y_axis_label: "${specs.yMainAxisTitle}",`,
            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}",`,
            '})',

            'main_chart.add_tools(new Bokeh.HoverTool({tooltips:main_tooltip, point_policy:"snap_to_data", mode:"mouse"}))',
            'main_chart.add_tools(new Bokeh.BoxZoomTool())',
            'main_chart.toolbar.active_drag = "box_zoom"',
            'main_chart.add_tools(new Bokeh.PanTool())',

            'main_chart.xaxis[0].axis_label_text_font = "PT Sans"',
            'main_chart.yaxis[0].axis_label_text_font = "PT Sans"',
            'main_chart.xaxis[0].axis_label_text_font_style = "normal"',
            'main_chart.yaxis[0].axis_label_text_font_style = "normal"',
            `main_chart.xaxis[0].axis_label_text_font_size = "${hasBraggData && specs.showBragg ? 0 : specs.fontPixelSize}px"`,
            `main_chart.yaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `main_chart.xaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `main_chart.yaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `main_chart.xaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,
            `main_chart.yaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,

            'main_chart.xaxis[0].axis_line_color = null',
            'main_chart.yaxis[0].axis_line_color = null',

            'main_chart.xaxis[0].major_label_text_font = "PT Sans"',
            'main_chart.yaxis[0].major_label_text_font = "PT Sans"',
            `main_chart.xaxis[0].major_label_text_font_size = "${hasBraggData && specs.showBragg ? 0 : specs.fontPixelSize}px"`,
            `main_chart.yaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `main_chart.xaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `main_chart.yaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `main_chart.xaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `main_chart.yaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `main_chart.xaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `main_chart.yaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,

            'main_chart.xaxis[0].major_tick_in = 0',
            'main_chart.yaxis[0].major_tick_in = 0',
            'main_chart.xaxis[0].major_tick_out = 0',
            'main_chart.yaxis[0].major_tick_out = 0',
            'main_chart.xaxis[0].minor_tick_out = 0',
            'main_chart.yaxis[0].minor_tick_out = 0',

            `main_chart.xgrid[0].grid_line_color = "${specs.chartGridLineColor}"`,
            `main_chart.ygrid[0].grid_line_color = "${specs.chartGridLineColor}"`,

            'main_chart.min_border = 0',

            'charts.push([main_chart])'
        ])

    // Main chart (top): Measured area
    if (hasMeasuredData && specs.showMeasured) {
        list = list.concat([
            `source.data.x_meas = ${data.measured.x}`,
            `source.data.y_meas = ${data.measured.y}`,
            `source.data.y_meas_top = ${data.measured.y_top}`,
            `source.data.y_meas_bottom = ${data.measured.y_bottom}`,

            'const measLineTop = new Bokeh.Line({',
            '    x: { field: "x_meas" },',
            '    y: { field: "y_meas_top" },',
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.measuredLineWidth}`,
            '})',
            'const measLineBottom = new Bokeh.Line({',
            '    x: { field: "x_meas" },',
            '    y: { field: "y_meas_bottom" },',
            `    line_color: "${specs.measuredLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.measuredLineWidth}`,
            '})',
            'const measArea = new Bokeh.VArea({',
            '    x: { field: "x_meas" },',
            '    y1: { field: "y_meas_top" },',
            '    y2: { field: "y_meas_bottom" },',
            `    fill_color: "${specs.measuredAreaColor}",`,
            `    fill_alpha: 0.33`,
            '})',

            'main_chart.add_glyph(measArea, source)',
            'main_chart.add_glyph(measLineTop, source)',
            'main_chart.add_glyph(measLineBottom, source)'
        ])
    }

    // Main chart (top): Calculated curve
    if (hasCalculatedData && specs.showCalculated) {
        list = list.concat([
            `source.data.x_calc = ${data.calculated.x}`,
            `source.data.y_calc = ${data.calculated.y}`,

            'const calcLine = new Bokeh.Line({',
            '    x: { field: "x_calc" },',
            '    y: { field: "y_calc" },',
            `    line_color: "${specs.calculatedLineColor}",`,
            `    line_width: ${specs.calculatedLineWidth},`,
            '})',

            'main_chart.add_glyph(calcLine, source)'
        ])
    }

    // Bragg peaks chart (middle)
    if (hasBraggData && specs.showBragg) {
        list = list.concat([
            'let bragg_chart = new Bokeh.Plotting.figure({',
            '   tools: "",',
            `   height: ${specs.braggChartHeight},`,
            `   width: ${specs.chartWidth},`,
            '   x_range: main_chart.x_range,',
            '   y_range: new Bokeh.Range1d({ start: -1, end: 1 }),',
            '   outline_line_color: null,',
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}"`,
            '})',

            'bragg_chart.add_tools(new Bokeh.HoverTool({tooltips:bragg_tooltip, point_policy:"snap_to_data", mode:"mouse"}))',

            'bragg_chart.xaxis[0].axis_line_color = null',
            'bragg_chart.yaxis[0].axis_line_color = null',
            'bragg_chart.xaxis[0].major_tick_in = 0',
            'bragg_chart.yaxis[0].major_tick_in = 0',
            'bragg_chart.xaxis[0].major_tick_out = 0',
            'bragg_chart.yaxis[0].major_tick_out = 0',
            'bragg_chart.xaxis[0].minor_tick_out = 0',
            'bragg_chart.yaxis[0].minor_tick_out = 0',
            'bragg_chart.xaxis[0].major_label_text_font_size = "0px"',
            'bragg_chart.yaxis[0].major_label_text_font_size = "0px"',
            'bragg_chart.xgrid[0].grid_line_color = null',
            'bragg_chart.ygrid[0].grid_line_color = null',
            'bragg_chart.min_border = 0',

            `source.data.x_bragg = ${data.bragg.x}`,
            `source.data.y_bragg = ${data.bragg.y}`,

            'const braggTicks = new Bokeh.Dash({',
            '    x: { field: "x_bragg" },',
            '    y: { field: "y_bragg" },',
            `    line_color: "${specs.braggTicksColor}",`,
            `    angle: Math.PI / 2.`,
            '})',

            'bragg_chart.add_glyph(braggTicks, source)',

            'charts.push([bragg_chart])'
        ])
    }

    // Difference chart (bottom)
    if (hasDifferenceData  && specs.showDifference) {
        list = list.concat([
            `const ratio = 0.5 * (${specs.differenceChartHeight} - 3*${specs.fontPixelSize}) / (${specs.mainChartHeight} + 30)`,
            'let diff_chart = new Bokeh.Plotting.figure({',
            '   tools: "reset",',
            `   height: ${specs.differenceChartHeight},`,
            `   width: ${specs.chartWidth},`,
            '   x_range: main_chart.x_range,',
            `   y_range: new Bokeh.Range1d({`,
            `       start: ${data.difference.median_y} - (main_chart.y_range.start - main_chart.y_range.end) * ratio,`,
            `       end: ${data.difference.median_y} + (main_chart.y_range.start - main_chart.y_range.end) * ratio`,
            `   }),`,
            `   x_axis_label: "${specs.xAxisTitle}",`,
            `   y_axis_label: "${specs.yDifferenceAxisTitle}",`,
            `   outline_line_color: "${EaStyle.Colors.chartAxis}",`,
            `   background: "${specs.chartBackgroundColor}",`,
            `   background_fill_color: "${specs.chartBackgroundColor}",`,
            `   border_fill_color: "${specs.chartBackgroundColor}"`,
            '})',

            'diff_chart.add_tools(new Bokeh.HoverTool({tooltips:main_tooltip, point_policy:"snap_to_data", mode:"mouse"}))',
            'diff_chart.add_tools(new Bokeh.BoxZoomTool())',
            'diff_chart.toolbar.active_drag = "box_zoom"',
            'diff_chart.add_tools(new Bokeh.PanTool())',

            'diff_chart.xaxis[0].axis_label_text_font = "PT Sans"',
            'diff_chart.yaxis[0].axis_label_text_font = "PT Sans"',
            'diff_chart.xaxis[0].axis_label_text_font_style = "normal"',
            'diff_chart.yaxis[0].axis_label_text_font_style = "normal"',
            `diff_chart.xaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `diff_chart.yaxis[0].axis_label_text_font_size = "${specs.fontPixelSize}px"`,
            `diff_chart.xaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `diff_chart.yaxis[0].axis_label_text_color = "${specs.chartForegroundColor}"`,
            `diff_chart.xaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,
            `diff_chart.yaxis[0].axis_label_standoff = ${specs.fontPixelSize}`,

            'diff_chart.xaxis[0].axis_line_color = null',
            'diff_chart.yaxis[0].axis_line_color = null',

            'diff_chart.xaxis[0].major_label_text_font = "PT Sans"',
            'diff_chart.yaxis[0].major_label_text_font = "PT Sans"',
            `diff_chart.xaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `diff_chart.yaxis[0].major_label_text_font_size = "${specs.fontPixelSize}px"`,
            `diff_chart.xaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `diff_chart.yaxis[0].major_label_text_color = "${specs.chartForegroundColor}"`,
            `diff_chart.xaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `diff_chart.yaxis[0].major_tick_line_color = "${specs.chartGridLineColor}"`,
            `diff_chart.xaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,
            `diff_chart.yaxis[0].minor_tick_line_color = "${specs.chartMinorGridLineColor}"`,

            'diff_chart.xaxis[0].major_tick_in = 0',
            'diff_chart.yaxis[0].major_tick_in = 0',
            'diff_chart.xaxis[0].major_tick_out = 0',
            'diff_chart.yaxis[0].major_tick_out = 0',
            'diff_chart.xaxis[0].minor_tick_out = 0',
            'diff_chart.yaxis[0].minor_tick_out = 0',

            `diff_chart.xgrid[0].grid_line_color = "${specs.chartGridLineColor}"`,
            `diff_chart.ygrid[0].grid_line_color = "${specs.chartGridLineColor}"`,
            'diff_chart.ygrid[0].ticker.desired_num_ticks = 3',

            'diff_chart.min_border = 0',

            `source.data.x_diff = ${data.difference.x}`,
            `source.data.y_diff = ${data.difference.y}`,
            `source.data.y_diff_top = ${data.difference.y_top}`,
            `source.data.y_diff_bottom = ${data.difference.y_bottom}`,

            'const diffLineTop = new Bokeh.Line({',
            '    x: { field: "x_diff" },',
            '    y: { field: "y_diff_top" },',
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.differenceLineWidth}`,
            '})',
            'const diffLineBottom = new Bokeh.Line({',
            '    x: { field: "x_diff" },',
            '    y: { field: "y_diff_bottom" },',
            `    line_color: "${specs.differenceLineColor}",`,
            `    line_alpha: 0.5,`,
            `    line_width: ${specs.differenceLineWidth}`,
            '})',
            'const diffArea = new Bokeh.VArea({',
            '    x: { field: "x_diff" },',
            '    y1: { field: "y_diff_top" },',
            '    y2: { field: "y_diff_bottom" },',
            `    fill_color: "${specs.differenceAreaColor}",`,
            `    fill_alpha: 0.33`,
            '})',

            'diff_chart.add_glyph(diffArea, source)',
            'diff_chart.add_glyph(diffLineTop, source)',
            'diff_chart.add_glyph(diffLineBottom, source)',

            'charts.push([diff_chart])'
        ])
    }

    // Grid layout
    list = list.concat(['const gridplot = new Bokeh.Plotting.gridplot(charts)'])

    // Show plots
    if (typeof specs.containerId !== 'undefined') {
        list = list.concat([`Bokeh.Plotting.show(gridplot, "#${specs.containerId}")`])
    } else {
        list = list.concat(['Bokeh.Plotting.show(gridplot)'])
    }

    return list.join('\n')
}
