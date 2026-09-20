import QtQuick

Item {
    id: root
    width: 180
    height: 180

    property string timeStr: ""
    property string dateStr: ""
    property real secondProgress: 0

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.updateTime()
    }

    Component.onCompleted: updateTime()

    function updateTime() {
        var now = new Date()
        var h = now.getHours()
        var m = now.getMinutes()
        var s = now.getSeconds()
        timeStr = String(h).padStart(2, '0') + ":" + String(m).padStart(2, '0')
        dateStr = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][now.getDay()] + ", " +
                  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][now.getMonth()] + " " +
                  now.getDate()
        secondProgress = s / 60
    }

    // Glass background
    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(0.12, 0.12, 0.15, 0.55)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1
    }

    Canvas {
        id: ringCanvas
        anchors.fill: parent
        onPaint: drawRing()

        Connections {
            target: root
            function onSecondProgressChanged() { ringCanvas.requestPaint() }
        }

        function drawRing() {
            var ctx = getContext("2d")
            var cx = width / 2
            var cy = height / 2
            var r = Math.min(cx, cy) - 16

            ctx.clearRect(0, 0, width, height)

            // Background ring
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 2)
            ctx.strokeStyle = "rgba(255,255,255,0.08)"
            ctx.lineWidth = 3
            ctx.stroke()

            // Tick marks
            for (var i = 0; i < 60; i++) {
                var angle = (i / 60) * Math.PI * 2 - Math.PI / 2
                var isHour = i % 5 === 0
                var innerR = r - (isHour ? 8 : 4)
                var outerR = r + 1

                ctx.beginPath()
                ctx.moveTo(cx + Math.cos(angle) * innerR, cy + Math.sin(angle) * innerR)
                ctx.lineTo(cx + Math.cos(angle) * outerR, cy + Math.sin(angle) * outerR)
                ctx.strokeStyle = isHour ? "rgba(255,255,255,0.5)" : "rgba(255,255,255,0.15)"
                ctx.lineWidth = isHour ? 2 : 1
                ctx.stroke()
            }

            // Second progress arc
            var startAngle = -Math.PI / 2
            var endAngle = startAngle + root.secondProgress * Math.PI * 2
            ctx.beginPath()
            ctx.arc(cx, cy, r, startAngle, endAngle)
            ctx.strokeStyle = "rgba(246,160,41,0.7)"
            ctx.lineWidth = 3
            ctx.lineCap = "round"
            ctx.stroke()

            // Comet dot at end of arc
            var dotX = cx + Math.cos(endAngle) * r
            var dotY = cy + Math.sin(endAngle) * r
            ctx.beginPath()
            ctx.arc(dotX, dotY, 4, 0, Math.PI * 2)
            ctx.fillStyle = "#F6A029"
            ctx.fill()
        }
    }

    // Time display
    Column {
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.timeStr
            color: "#ffffff"
            font.pixelSize: 36
            font.family: "Barlow Medium"
            font.weight: Font.Bold
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.dateStr
            color: Qt.rgba(1, 1, 1, 0.5)
            font.pixelSize: 11
        }
    }
}
