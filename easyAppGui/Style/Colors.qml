pragma Singleton

import QtQuick 2.13
import QtQuick.Controls.Material 2.13

QtObject {

    // Theme
    enum Themes { DarkTheme = 0, LightTheme }

    property int theme: systemTheme//Colors.Themes.DarkTheme
    property bool isDarkTheme: theme === Colors.Themes.DarkTheme

    property color themeAccent: isDarkTheme ? "#4ec1ef": "#00a3e3"
    property color themePrimary: isDarkTheme ? "#222" : "#ddd"
    property color themeBackground: isDarkTheme ? "#333" : "#e9e9e9"
    property color themeForeground: isDarkTheme ? "#eee" : "#333"
    property color themeForegroundDisabled: isDarkTheme ? "#888": "#bbb" // control.Material.hintTextColor

    // System theme
    property var _systemThemeChecker: Item { Material.theme: Material.System }
    property int systemTheme: _systemThemeChecker.Material.theme === Material.Dark ?
                                  Colors.Themes.DarkTheme :
                                  Colors.Themes.LightTheme

    // Ripple
    property color rippleHovered: isDarkTheme ? "#75666666" : "#75999999"
    property color ripplePressed: isDarkTheme ? "#75777777" : "#75888888"

    // Application window
    property color appBorder: isDarkTheme ? "#262626" : "#ddd"

    // Application bar (on top of the application window)
    property color appBarBackground: themeBackground
    property color appBarForeground: isDarkTheme ? "#eee" : "#222"
    property color appBarBorder: isDarkTheme ? "#2e2e2e" : "#d6d6d6"

    property color appBarButtonBackground: "transparent"
    property color appBarButtonBackgroundHovered: "transparent"//isDarkTheme ? "#50666666" : "#20666666" // temporary disable because of problems with RemoteController if parent: Overlay.overlay !?
    property color appBarButtonBackgroundPressed: isDarkTheme ? "#90666666" : "#40666666"
    property color appBarButtonForeground: isDarkTheme ? "#ccc" : "#444"

    property color appBarComboBoxBackground: isDarkTheme ? "#10666666" : "#70ffffff"
    property color appBarComboBoxBackgroundHovered: isDarkTheme ? "#50666666" : "#bbffffff"
    property color appBarComboBoxBackgroundPressed: isDarkTheme ? "#90666666" : "#ffffffff"
    property color appBarComboBoxBorder: isDarkTheme ? Qt.darker(appBarBackground, 1.1) : Qt.darker(appBarBackground, 1.05)

    // Content
    property color contentBackground: isDarkTheme ? "#3a3a3a" : "#f4f4f4"
    property color mainContentBackground: isDarkTheme ? "#474747" : "#fff"

    // SideBar
    property color sideBarButtonBackground: isDarkTheme ? "#333" : "#e9e9e9"
    property color sideBarButtonBackgroundHovered: isDarkTheme ? "#222" : "#20666666"
    property color sideBarButtonBackgroundPressed: isDarkTheme ? "#111" : "#40666666"
    property color sideBarButtonForeground: isDarkTheme ? "#ccc" : "#444"

    // Status bar
    readonly property color statusBarBackground: appBarBackground
    readonly property color statusBarForeground: isDarkTheme ? "#aaa" : "#666"

    // Dialogs
    property color dialogBackground: themeBackground
    property color dialogOutsideBackground: isDarkTheme ? "#80000000" : "#80ffffff"
    property color dialogForeground: themeForeground

    // Charts
    property color chartForeground: themeForeground
    property color chartBackground: "transparent"
    property color chartPlotAreaBackground: "transparent"


}
