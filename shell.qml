import QtQuick
import Quickshell
import "components" as Components

ShellRoot {
    Components.WidgetWindow {
        widgetName: "clock-analog"
        posX: 50
        posY: 50
        widgetWidth: 180
        widgetHeight: 180

        Loader {
            anchors.fill: parent
            source: "widgets/clockAnalog/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "clock-digital"
        posX: 280
        posY: 50
        widgetWidth: 180
        widgetHeight: 180

        Loader {
            anchors.fill: parent
            source: "widgets/clockDigital/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "clock-world"
        posX: 510
        posY: 50
        widgetWidth: 340
        widgetHeight: 260

        Loader {
            anchors.fill: parent
            source: "widgets/clockWorld/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "music"
        posX: 50
        posY: 280
        widgetWidth: 300
        widgetHeight: 90

        Loader {
            anchors.fill: parent
            source: "widgets/music/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "weather"
        posX: 400
        posY: 280
        widgetWidth: 340
        widgetHeight: 420

        Loader {
            anchors.fill: parent
            source: "widgets/weather/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "calendar"
        posX: 50
        posY: 420
        widgetWidth: 340
        widgetHeight: 240

        Loader {
            anchors.fill: parent
            source: "widgets/calendar/main.qml"
        }
    }

    Components.WidgetWindow {
        widgetName: "timer"
        posX: 790
        posY: 50
        widgetWidth: 220
        widgetHeight: 380

        Loader {
            anchors.fill: parent
            source: "widgets/timer/main.qml"
        }
    }
}
