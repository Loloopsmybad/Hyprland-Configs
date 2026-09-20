import QtQuick

Item {
    id: root
    anchors.fill: parent

    property var cities: [
        { name: "LA", fullName: "Los Angeles", offset: -7, today: "Today" },
        { name: "LON", fullName: "London", offset: 1, today: "Today" },
        { name: "TYO", fullName: "Tokyo", offset: 9, today: "Today" },
        { name: "SYD", fullName: "Sydney", offset: 11, today: "Today" }
    ]

    function getCityTime(utcOffset) {
        var now = new Date()
        var utc = now.getTime() + now.getTimezoneOffset() * 60000
        var cityDate = new Date(utc + utcOffset * 3600000)
        return cityDate
    }

    function formatHour12(h) {
        var hr = h % 12
        if (hr === 0) hr = 12
        return String(hr)
    }

    property int tick: 0

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.tick++
    }

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
        anchors.margins: 12
        spacing: 8

        Text {
            text: "World Clocks"
            color: "#ffffff"
            font.pixelSize: 12
            font.weight: Font.Bold
        }

        Repeater {
            model: root.cities

            Rectangle {
                width: parent.width
                height: 50
                radius: 10
                color: Qt.rgba(1, 1, 1, 0.05)

                Row {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    // Mini analog clock
                    Canvas {
                        id: miniClock
                        width: 36
                        height: 36
                        anchors.verticalCenter: parent.verticalCenter
                        onPaint: drawMiniClock()

                        Connections {
                            target: root
                            function onTickChanged() { miniClock.requestPaint() }
                        }

                        function drawMiniClock() {
                            var ctx = getContext("2d")
                            var cx = width / 2
                            var cy = height / 2
                            var r = cx - 2
                            var cityTime = root.getCityTime(modelData.offset)

                            ctx.clearRect(0, 0, width, height)

                            // Face
                            ctx.beginPath()
                            ctx.arc(cx, cy, r, 0, Math.PI * 2)
                            ctx.fillStyle = "rgba(255,255,255,0.06)"
                            ctx.fill()
                            ctx.strokeStyle = "rgba(255,255,255,0.15)"
                            ctx.lineWidth = 1
                            ctx.stroke()

                            // Hour ticks
                            for (var i = 0; i < 12; i++) {
                                var a = (i / 12) * Math.PI * 2 - Math.PI / 2
                                ctx.beginPath()
                                ctx.moveTo(cx + Math.cos(a) * (r - 3), cy + Math.sin(a) * (r - 3))
                                ctx.lineTo(cx + Math.cos(a) * r, cy + Math.sin(a) * r)
                                ctx.strokeStyle = "rgba(255,255,255,0.3)"
                                ctx.lineWidth = 1
                                ctx.stroke()
                            }

                            // Hour hand
                            var h = cityTime.getHours() % 12
                            var m = cityTime.getMinutes()
                            var hAngle = ((h + m / 60) / 12) * Math.PI * 2 - Math.PI / 2
                            ctx.beginPath()
                            ctx.moveTo(cx, cy)
                            ctx.lineTo(cx + Math.cos(hAngle) * r * 0.5, cy + Math.sin(hAngle) * r * 0.5)
                            ctx.strokeStyle = "rgba(255,255,255,0.8)"
                            ctx.lineWidth = 1.5
                            ctx.lineCap = "round"
                            ctx.stroke()

                            // Minute hand
                            var mAngle = ((m + cityTime.getSeconds() / 60) / 60) * Math.PI * 2 - Math.PI / 2
                            ctx.beginPath()
                            ctx.moveTo(cx, cy)
                            ctx.lineTo(cx + Math.cos(mAngle) * r * 0.7, cy + Math.sin(mAngle) * r * 0.7)
                            ctx.strokeStyle = "rgba(255,255,255,0.6)"
                            ctx.lineWidth = 1
                            ctx.lineCap = "round"
                            ctx.stroke()

                            // Center dot
                            ctx.beginPath()
                            ctx.arc(cx, cy, 1.5, 0, Math.PI * 2)
                            ctx.fillStyle = "#F6A029"
                            ctx.fill()
                        }
                    }

                    // City info
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: modelData.fullName
                            color: "#ffffff"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                        }

                        Text {
                            text: modelData.today + " · " + (modelData.offset >= 0 ? "+" : "") + modelData.offset + " HRS"
                            color: Qt.rgba(1, 1, 1, 0.4)
                            font.pixelSize: 9
                        }
                    }

                    // Digital time
                    Item { width: parent.width - 36 - 100 - 8 * 3; height: 1 }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: {
                            var ct = root.getCityTime(modelData.offset)
                            return String(ct.getHours()).padStart(2, '0') + ":" + String(ct.getMinutes()).padStart(2, '0')
                        }
                        color: "#ffffff"
                        font.pixelSize: 18
                        font.family: "Barlow Medium"
                        font.weight: Font.Bold
                    }
                }
            }
        }
    }
}
