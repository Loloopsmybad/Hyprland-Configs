import QtQuick

Item {
    id: root
    width: 180
    height: 180

    property real secondAngle: 0
    property real minuteAngle: 0
    property real hourAngle: 0

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.updateHands()
    }

    Component.onCompleted: updateHands()

    function updateHands() {
        const now = new Date()
        const s = now.getSeconds()
        const m = now.getMinutes()
        const h = now.getHours() % 12
        secondAngle = (s / 60) * 360
        minuteAngle = ((m + s / 60) / 60) * 360
        hourAngle = ((h + m / 60) / 12) * 360
    }

    // Glass background
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: Qt.rgba(0.12, 0.12, 0.15, 0.55)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1
    }

    Canvas {
        id: clockCanvas
        anchors.fill: parent
        onPaint: drawClock()

        Connections {
            target: root
            function onSecondAngleChanged() { clockCanvas.requestPaint() }
        }

        function drawClock() {
            var ctx = getContext("2d")
            var cx = width / 2
            var cy = height / 2
            var r = Math.min(cx, cy) - 4

            ctx.clearRect(0, 0, width, height)

            // Tick marks
            for (var i = 0; i < 60; i++) {
                var angle = (i / 60) * Math.PI * 2 - Math.PI / 2
                var isHour = i % 5 === 0
                var innerR = isHour ? r - 10 : r - 5
                var outerR = r - 1

                ctx.beginPath()
                ctx.moveTo(cx + Math.cos(angle) * innerR, cy + Math.sin(angle) * innerR)
                ctx.lineTo(cx + Math.cos(angle) * outerR, cy + Math.sin(angle) * outerR)
                ctx.strokeStyle = isHour ? "rgba(255,255,255,0.8)" : "rgba(255,255,255,0.25)"
                ctx.lineWidth = isHour ? 2 : 1
                ctx.stroke()
            }

            // Hour numbers
            ctx.fillStyle = "rgba(255,255,255,0.7)"
            ctx.font = "11px 'Barlow Medium'"
            ctx.textAlign = "center"
            ctx.textBaseline = "middle"
            for (var j = 1; j <= 12; j++) {
                var a = (j / 12) * Math.PI * 2 - Math.PI / 2
                var numR = r - 18
                ctx.fillText(String(j), cx + Math.cos(a) * numR, cy + Math.sin(a) * numR)
            }

            // Hour hand
            var hRad = (root.hourAngle - 90) * Math.PI / 180
            drawHand(ctx, cx, cy, hRad, r * 0.45, 3.5, "rgba(255,255,255,0.9)")

            // Minute hand
            var mRad = (root.minuteAngle - 90) * Math.PI / 180
            drawHand(ctx, cx, cy, mRad, r * 0.65, 2.5, "rgba(255,255,255,0.8)")

            // Second hand
            var sRad = (root.secondAngle - 90) * Math.PI / 180
            drawHand(ctx, cx, cy, sRad, r * 0.7, 1.2, "#F6A029")

            // Center dot
            ctx.beginPath()
            ctx.arc(cx, cy, 4, 0, Math.PI * 2)
            ctx.fillStyle = "#F6A029"
            ctx.fill()
        }

        function drawHand(ctx, cx, cy, angle, length, width, color) {
            ctx.beginPath()
            ctx.moveTo(cx, cy)
            ctx.lineTo(cx + Math.cos(angle) * length, cy + Math.sin(angle) * length)
            ctx.strokeStyle = color
            ctx.lineWidth = width
            ctx.lineCap = "round"
            ctx.stroke()
        }
    }
}
