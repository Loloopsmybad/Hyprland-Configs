import QtQuick

Item {
    id: root
    anchors.fill: parent

    property int totalSeconds: 0
    property int remainingSeconds: 0
    property bool running: false
    property bool finished: false
    property bool hasDuration: totalSeconds > 0

    function formatTime(s) {
        const h = Math.floor(s / 3600)
        const m = Math.floor((s % 3600) / 60)
        const sec = s % 60
        if (h > 0) return `${h}:${String(m).padStart(2,'0')}:${String(sec).padStart(2,'0')}`
        return `${String(m).padStart(2,'0')}:${String(sec).padStart(2,'0')}`
    }

    function setDuration(seconds) {
        totalSeconds = seconds
        remainingSeconds = seconds
        running = false
        finished = false
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.running
        onTriggered: {
            if (root.remainingSeconds > 0) {
                root.remainingSeconds--
                if (root.remainingSeconds === 0) {
                    root.running = false
                    root.finished = true
                }
            }
        }
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
        anchors.centerIn: parent
        spacing: 16

        // Timer display
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.hasDuration ? root.formatTime(root.remainingSeconds) : "00:00"
            color: root.finished ? "#ff4444" : "#ffffff"
            font.pixelSize: 48
            font.family: "Barlow Medium"
            font.weight: Font.Bold
        }

        // Presets label + buttons
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Text {
                text: "Presets"
                color: Qt.rgba(1, 1, 1, 0.4)
                font.pixelSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Repeater {
                model: [
                    { label: "1 min", seconds: 60 },
                    { label: "2 min", seconds: 120 },
                    { label: "3 min", seconds: 180 },
                    { label: "5 min", seconds: 300 }
                ]

                Rectangle {
                    width: 140
                    height: 32
                    radius: 8
                    color: root.totalSeconds === modelData.seconds
                           ? Qt.rgba(1, 1, 1, 0.15)
                           : Qt.rgba(1, 1, 1, 0.05)
                    border.color: root.totalSeconds === modelData.seconds
                                  ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData.label
                        color: "#ffffff"
                        font.pixelSize: 12
                        font.family: "Barlow Medium"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.setDuration(modelData.seconds)
                    }
                }
            }
        }

        // Play / Pause / Reset buttons
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            // Reset
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: Qt.rgba(1, 1, 1, 0.1)
                visible: root.hasDuration

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: "#ffffff"
                    font.pixelSize: 16
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.running = false
                        root.remainingSeconds = root.totalSeconds
                        root.finished = false
                    }
                }
            }

            // Play / Pause
            Rectangle {
                width: 56
                height: 56
                radius: 28
                color: root.running ? Qt.rgba(1, 0.6, 0, 0.9) : Qt.rgba(0.2, 0.8, 0.2, 0.9)
                visible: root.hasDuration

                Text {
                    anchors.centerIn: parent
                    text: root.running ? "⏸" : "▶"
                    color: "#ffffff"
                    font.pixelSize: 20
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.running = !root.running
                }
            }

            // Stop
            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: Qt.rgba(1, 1, 1, 0.1)
                visible: root.running

                Text {
                    anchors.centerIn: parent
                    text: "■"
                    color: "#ffffff"
                    font.pixelSize: 14
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.running = false
                        root.remainingSeconds = 0
                        root.finished = false
                    }
                }
            }
        }
    }
}
