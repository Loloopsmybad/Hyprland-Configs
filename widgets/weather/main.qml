import QtQuick

Item {
    id: root
    anchors.fill: parent

    property real temperature: 0
    property real tempHigh: 0
    property real tempLow: 0
    property string condition: ""
    property string conditionIcon: ""
    property string windDir: ""
    property real windSpeed: 0
    property string location: "Loading..."
    property var hourlyTemps: []
    property var hourlyIcons: []
    property var hourlyHours: []
    property var dailyDays: []
    property var dailyIcons: []
    property var dailyHighs: []
    property var dailyLows: []
    property bool loaded: false

    function fetchWeather() {
        const lat = 28.6139
        const lon = 77.2090
        const url = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}` +
            `&current=temperature_2m,weather_code,wind_speed_10m,wind_direction_10m` +
            `&hourly=temperature_2m,weather_code` +
            `&daily=weather_code,temperature_2m_max,temperature_2m_min` +
            `&timezone=auto&forecast_days=7`

        const xhr = new XMLHttpRequest()
        xhr.open("GET", url)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                const data = JSON.parse(xhr.responseText)
                const c = data.current
                root.temperature = Math.round(c.temperature_2m)
                root.condition = codeToText(c.weather_code)
                root.conditionIcon = codeToIcon(c.weather_code)
                root.windSpeed = Math.round(c.wind_speed_10m)
                root.windDir = degToDir(c.wind_direction_10m)
                root.location = "Delhi"

                // Hourly (next 12)
                const now = new Date().getHours()
                var hTemps = [], hIcons = [], hHours = []
                for (var i = now; i < Math.min(now + 12, data.hourly.time.length); i++) {
                    hTemps.push(Math.round(data.hourly.temperature_2m[i]))
                    hIcons.push(codeToIcon(data.hourly.weather_code[i]))
                    hHours.push(String(i).padStart(2, '0') + ":00")
                }
                root.hourlyTemps = hTemps
                root.hourlyIcons = hIcons
                root.hourlyHours = hHours

                // Daily
                var dDays = [], dIcons = [], dHighs = [], dLows = []
                const dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                for (var j = 0; j < data.daily.time.length; j++) {
                    const dt = new Date(data.daily.time[j] + "T00:00:00")
                    dDays.push(dayNames[dt.getDay()])
                    dIcons.push(codeToIcon(data.daily.weather_code[j]))
                    dHighs.push(Math.round(data.daily.temperature_2m_max[j]))
                    dLows.push(Math.round(data.daily.temperature_2m_min[j]))
                }
                root.dailyDays = dDays
                root.dailyIcons = dIcons
                root.dailyHighs = dHighs
                root.dailyLows = dLows
                root.loaded = true
            }
        }
        xhr.send()
        weatherTimer.restart()
    }

    function codeToText(code) {
        if (code === 0) return "Clear"
        if (code <= 3) return "Overcast"
        if (code <= 49) return "Fog"
        if (code <= 59) return "Drizzle"
        if (code <= 69) return "Rain"
        if (code <= 79) return "Snow"
        if (code <= 82) return "Rain"
        if (code <= 86) return "Snow"
        if (code <= 99) return "Storm"
        return "Unknown"
    }

    function codeToIcon(code) {
        if (code === 0) return "☀️"
        if (code <= 3) return "⛅"
        if (code <= 49) return "🌫️"
        if (code <= 59) return "🌧️"
        if (code <= 69) return "🌧️"
        if (code <= 79) return "❄️"
        if (code <= 82) return "🌧️"
        if (code <= 86) return "❄️"
        if (code <= 99) return "⛈️"
        return "❓"
    }

    function degToDir(deg) {
        const dirs = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        return dirs[Math.round(deg / 45) % 8]
    }

    Timer {
        id: weatherTimer
        interval: 1800000
        repeat: true
        running: true
        onTriggered: root.fetchWeather()
    }

    Component.onCompleted: Qt.callLater(function() { root.fetchWeather() })

    // Glass background
    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(0.12, 0.12, 0.15, 0.55)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1
    }

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header: location + temp + condition
        Row {
            spacing: 12
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: root.location
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                }

                Text {
                    text: root.loaded ? root.condition : ""
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 11
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    text: root.loaded ? root.conditionIcon + " " + root.temperature + "°" : ""
                    color: "#ffffff"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                }

                Text {
                    text: root.loaded ? "H:" + root.tempHigh + "° L:" + root.tempLow + "°" : ""
                    color: Qt.rgba(1, 1, 1, 0.5)
                    font.pixelSize: 10
                }
            }
        }

        // Hourly forecast
        Rectangle {
            width: parent.width
            height: 70
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.05)

            Row {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 0

                Repeater {
                    model: root.hourlyHours.length

                    Column {
                        width: (parent.width - 16) / Math.max(root.hourlyHours.length, 1)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.hourlyHours[index] ?? ""
                            color: Qt.rgba(1, 1, 1, 0.5)
                            font.pixelSize: 9
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.hourlyIcons[index] ?? ""
                            font.pixelSize: 14
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: (root.hourlyTemps[index] !== undefined) ? root.hourlyTemps[index] + "°" : ""
                            color: "#ffffff"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                }
            }
        }

        // Wind
        Row {
            spacing: 6
            visible: root.loaded

            Text {
                text: "💨"
                font.pixelSize: 11
            }

            Text {
                text: root.windSpeed + " km/h " + root.windDir
                color: Qt.rgba(1, 1, 1, 0.5)
                font.pixelSize: 10
            }
        }

        // Weekly forecast
        Column {
            width: parent.width
            spacing: 2

            Repeater {
                model: root.dailyDays.length

                Rectangle {
                    width: parent.width
                    height: 28
                    radius: 6
                    color: index === 0 ? Qt.rgba(1, 1, 1, 0.05) : "transparent"

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        Text {
                            width: parent.width * 0.25
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.dailyDays[index] ?? ""
                            color: "#ffffff"
                            font.pixelSize: 11
                        }

                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: root.dailyIcons[index] ?? ""
                            font.pixelSize: 14
                        }

                        Text {
                            width: parent.width * 0.25
                            anchors.verticalCenter: parent.verticalCenter
                            text: (root.dailyHighs[index] !== undefined) ? root.dailyHighs[index] + "°" : ""
                            color: "#ffffff"
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignRight
                        }

                        Text {
                            width: parent.width * 0.25
                            anchors.verticalCenter: parent.verticalCenter
                            text: (root.dailyLows[index] !== undefined) ? root.dailyLows[index] + "°" : ""
                            color: Qt.rgba(1, 1, 1, 0.4)
                            font.pixelSize: 11
                            horizontalAlignment: Text.AlignRight
                        }
                    }
                }
            }
        }
    }
}
