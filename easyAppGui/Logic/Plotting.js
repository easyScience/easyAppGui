// Common

function headCommon() {
    return '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>'
}

function charthHtml(head, chart) {
    const list = [
        '<!DOCTYPE html>',
        '<html>',
        '\n',
        '<head>',
        head,
        '</head>',
        '\n',
        '<body>',
        '<script>',
        chart,
        '</script>',
        '</body>',
        '\n',
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

function chemDoodleHtml(style) {
    const head = chemDoodleHead()
    const chart = chemDoodleChart(style)
    html = charthHtml(head, chart)
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

function chemDoodleChart(style) {
    const list = [
        'const cifStr = '+style.cifStr,
        'const xSuper = 1',
        'const ySuper = 1',
        'const zSuper = 1',
        'const phase = ChemDoodle.readCIF(cifStr, xSuper, ySuper, zSuper)',
        `const crystalTransformer = new ChemDoodle.TransformCanvas3D("crystalTransformer", ${style.chartWidth}, ${style.chartHeight})`,
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
        `crystalTransformer.styles.shapes_color = "${style.chartForegroundColor}"`,
        'crystalTransformer.styles.text_font_size = 12',
        'crystalTransformer.styles.text_font_families = ["Helvetica", "Arial", "Dialog"]',
        `crystalTransformer.styles.backgroundColor = "${style.chartBackgroundColor}"`,
        'crystalTransformer.loadContent([phase.molecule],[phase.unitCell])'
    ]
    return list.join('\n')
}

// Bokeh

function bokehInfo() {
    return {
        version: '2.2.3',
        url: 'https://docs.bokeh.org/en'
    }
}

function bokehHtml(style) {
    const head = bokehHead()
    const chart = bokehChart(style)
    html = charthHtml(head, chart)
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

function bokehChart(style) {
    const hasMeasuredData = typeof style.measuredData !== 'undefined' && typeof style.measuredData.x !== 'undefined'
    const hasCalculatedData = typeof style.calculatedData !== 'undefined' && typeof style.calculatedData.x !== 'undefined'
    let list = [
        'const plot = Bokeh.Plotting.figure({',
        '    tools: "pan,box_zoom,hover,reset",',
        `    height: ${style.chartHeight},`,
        `    width: ${style.chartWidth},`,
        `    x_axis_label: "${style.xAxisTitle}",`,
        `    y_axis_label: "${style.yAxisTitle}",`,
        `    background: "${style.chartBackgroundColor}",`,
        `    background_fill_color: "${style.chartBackgroundColor}",`,
        `    border_fill_color: "${style.chartBackgroundColor}",`,
        '})',
        'plot.x_range.range_padding = 0',
    ]
    if (hasMeasuredData) {
        list = list.concat([
            'const experimentSource = new Bokeh.ColumnDataSource({',
            '    data: {',
            `        x: ${style.measuredData.x},`,
            `        y: ${style.measuredData.y}`,
            '    }',
            '})',
            'const experimentLine = new Bokeh.Line({',
            '    x: { field: "x" },',
            '    y: { field: "y" },',
            `    line_color: "${style.experimentLineColor}",`,
            `    line_width: ${style.experimentLineWidth},`,
            '})',
            'plot.add_glyph(experimentLine, experimentSource)'
        ])
    }
    if (hasCalculatedData) {
        list = list.concat([
            'const calculatedSource = new Bokeh.ColumnDataSource({',
            '    data: {',
            `        x: ${style.calculatedData.x},`,
            `        y: ${style.calculatedData.y}`,
            '    }',
            '})',
            'const calculatedLine = new Bokeh.Line({',
            '    x: { field: "x" },',
            '    y: { field: "y" },',
            `    line_color: "${style.calculatedLineColor}",`,
            `    line_width: ${style.calculatedLineWidth},`,
            '})',
            'plot.add_glyph(calculatedLine, calculatedSource)'
        ])
    }
    if (typeof style.elementId !== 'undefined') {
        list = list.concat(['Bokeh.Plotting.show(plot, "#analysisSection")'])
    } else {
        list = list.concat(['Bokeh.Plotting.show(plot)'])
    }
    return list.join('\n')
}
