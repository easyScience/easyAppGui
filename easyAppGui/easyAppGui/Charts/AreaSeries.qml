import QtCharts 2.13

import easyAppGui.Style 1.0 as EaStyle

AreaSeries {
    opacity: 0.3

    color: EaStyle.Colors.themeAccent

    borderWidth: 1.5
    borderColor: Qt.darker(color, 1.1)
}
