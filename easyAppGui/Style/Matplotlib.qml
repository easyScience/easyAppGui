pragma Singleton

import QtQuick 2.13
import easyAppGui.Style 1.0 as EaStyle

QtObject {
    property var display: {
        'axes.grid' : true,
    }

    property var sizes: {
        'axes.labelpad': 12,
        'axes.linewidth': 0.75,
        'axes.xmargin': 0,
        'axes.ymargin': 0.05,

        'lines.linewidth': 2
    }

    property var colors: {
        'figure.facecolor': EaStyle.Colors.chartBackground.toString(),

        'axes.edgecolor': EaStyle.Colors.chartAxis.toString(),
        'axes.facecolor': EaStyle.Colors.chartPlotAreaBackground.toString(),
        'axes.labelcolor': EaStyle.Colors.chartLabels.toString(),

        'axes.prop_cycle': `cycler('color', ${JSON.stringify(EaStyle.Colors.chartForegrounds)})`,

        'grid.color': EaStyle.Colors.chartGridLine.toString(),
        'xtick.color': EaStyle.Colors.chartLabels.toString(),
        'ytick.color': EaStyle.Colors.chartLabels.toString(),
    }
}
