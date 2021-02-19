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
    let list = [
            'const plot = Bokeh.Plotting.figure({',
            '    tools: "pan,box_zoom,hover,reset",',
            `    height: ${specs.chartHeight},`,
            `    width: ${specs.chartWidth},`,
            `    x_axis_label: "${specs.xAxisTitle}",`,
            `    y_axis_label: "${specs.yAxisTitle}",`,
            `    background: "${specs.chartBackgroundColor}",`,
            `    background_fill_color: "${specs.chartBackgroundColor}",`,
            `    border_fill_color: "${specs.chartBackgroundColor}",`,
            '})',
            'const xaxis2 = new Bokeh.LinearAxis()',
            'const yaxis2 = new Bokeh.LinearAxis()',
            'plot.add_layout(xaxis2, "above")',
            'plot.add_layout(yaxis2, "right")',
            'plot.legend.label_text_font = "PT Sans"',
            'plot.xaxis[0].axis_label_text_font = "PT Sans"',
            'plot.yaxis[0].axis_label_text_font = "PT Sans"',
            `plot.xaxis[0].axis_label_text_font_style = "normal"`,
            `plot.yaxis[0].axis_label_text_font_style = "normal"`,
            `plot.xaxis[0].axis_label_text_font_size = "${EaStyle.Sizes.fontPixelSize}px"`,
            `plot.yaxis[0].axis_label_text_font_size = "${EaStyle.Sizes.fontPixelSize}px"`,
            `plot.xaxis[0].axis_label_text_color = "${EaStyle.Colors.chartForeground}"`,
            `plot.yaxis[0].axis_label_text_color = "${EaStyle.Colors.chartForeground}"`,
            `plot.xaxis[0].axis_line_color = "${EaStyle.Colors.chartAxis}"`,
            `plot.yaxis[0].axis_line_color = "${EaStyle.Colors.chartAxis}"`,
            `plot.xaxis[1].axis_line_color = "${EaStyle.Colors.chartAxis}"`,
            `plot.yaxis[1].axis_line_color = "${EaStyle.Colors.chartAxis}"`,
            `plot.xaxis[0].axis_label_standoff = ${EaStyle.Sizes.fontPixelSize}`,
            `plot.yaxis[0].axis_label_standoff = ${EaStyle.Sizes.fontPixelSize}`,
            'plot.xaxis[0].major_label_text_font = "PT Sans"',
            'plot.yaxis[0].major_label_text_font = "PT Sans"',
            `plot.xaxis[0].major_label_text_font_size = "${EaStyle.Sizes.fontPixelSize}px"`,
            `plot.yaxis[0].major_label_text_font_size = "${EaStyle.Sizes.fontPixelSize}px"`,
            'plot.xaxis[1].major_label_text_font_size = "0px"',
            'plot.yaxis[1].major_label_text_font_size = "0px"',
            `plot.xaxis[0].major_label_text_color = "${EaStyle.Colors.chartForeground}"`,
            `plot.yaxis[0].major_label_text_color = "${EaStyle.Colors.chartForeground}"`,
            `plot.xaxis[0].major_tick_line_color = "${EaStyle.Colors.chartGridLine}"`,
            `plot.yaxis[0].major_tick_line_color = "${EaStyle.Colors.chartGridLine}"`,
            `plot.xaxis[0].minor_tick_line_color = "${EaStyle.Colors.chartMinorGridLine}"`,
            `plot.yaxis[0].minor_tick_line_color = "${EaStyle.Colors.chartMinorGridLine}"`,
            'plot.xaxis[1].major_tick_in = 0',
            'plot.yaxis[1].major_tick_in = 0',
            'plot.xaxis[1].major_tick_out = 0',
            'plot.yaxis[1].major_tick_out = 0',
            'plot.xaxis[1].minor_tick_out = 0',
            'plot.yaxis[1].minor_tick_out = 0',
            `plot.xgrid[0].grid_line_color = "${EaStyle.Colors.chartGridLine}"`,
            `plot.ygrid[0].grid_line_color = "${EaStyle.Colors.chartGridLine}"`,
            'plot.x_range.range_padding = 0'
        ]
    if (hasMeasuredData) {
        list = list.concat([
            'const experimentSource = new Bokeh.ColumnDataSource({',
            '    data: {',
            `        x: ${data.measured.x},`,
            `        y: ${data.measured.y}`,
            '    }',
            '})',
            'const experimentLine = new Bokeh.Line({',
            '    x: { field: "x" },',
            '    y: { field: "y" },',
            `    line_color: "${specs.experimentLineColor}",`,
            `    line_width: ${specs.experimentLineWidth},`,
            '})',
            'plot.add_glyph(experimentLine, experimentSource)'
        ])
    }
    if (hasCalculatedData) {
        list = list.concat([
            'const calculatedSource = new Bokeh.ColumnDataSource({',
            '    data: {',
            `        x: ${data.calculated.x},`,
            `        y: ${data.calculated.y}`,
            '    }',
            '})',
            'const calculatedLine = new Bokeh.Line({',
            '    x: { field: "x" },',
            '    y: { field: "y" },',
            `    line_color: "${specs.calculatedLineColor}",`,
            `    line_width: ${specs.calculatedLineWidth},`,
            '})',
            'plot.add_glyph(calculatedLine, calculatedSource)'
        ])
    }
    if (typeof specs.containerId !== 'undefined') {
        list = list.concat([`Bokeh.Plotting.show(plot, "#${specs.containerId}")`])
    } else {
        list = list.concat(['Bokeh.Plotting.show(plot)'])
    }
    return list.join('\n')
}
