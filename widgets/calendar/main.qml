import QtQuick

Item {
    id: root
    anchors.fill: parent

    property date today: new Date()
    property int month: today.getMonth()
    property int year: today.getFullYear()

    function daysInMonth(m, y) { return new Date(y, m + 1, 0).getDate() }
    function firstDayOfWeek(m, y) { return new Date(y, m, 1).getDay() }
    function monthName(m) {
        return ["January","February","March","April","May","June",
            "July","August","September","October","November","December"][m]
    }

    // Glass background
    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(0.12, 0.12, 0.15, 0.55)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1
    }

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Calendar grid
        Column {
            width: parent.width * 0.55
            spacing: 6

            // Month header
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Text {
                    text: "◀"
                    font.pixelSize: 12
                    color: Qt.rgba(1, 1, 1, 0.5)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.month--
                            if (root.month < 0) { root.month = 11; root.year-- }
                        }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.monthName(root.month) + " " + root.year
                    color: "#ffffff"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                }

                Text {
                    text: "▶"
                    font.pixelSize: 12
                    color: Qt.rgba(1, 1, 1, 0.5)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.month++
                            if (root.month > 11) { root.month = 0; root.year++ }
                        }
                    }
                }
            }

            // Day names
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: ["S","M","T","W","T","F","S"]
                    Text {
                        width: 28
                        text: modelData
                        color: Qt.rgba(1, 1, 1, 0.35)
                        font.pixelSize: 9
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            // Day grid
            Grid {
                columns: 7
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Repeater {
                    model: root.firstDayOfWeek(root.month, root.year)
                    Item { width: 28; height: 22 }
                }

                Repeater {
                    model: root.daysInMonth(root.month, root.year)

                    Rectangle {
                        width: 28
                        height: 22
                        radius: 6
                        color: (index + 1 === root.today.getDate() &&
                                root.month === root.today.getMonth() &&
                                root.year === root.today.getFullYear())
                                ? Qt.rgba(0.9, 0.3, 0.3, 0.8) : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            color: (index + 1 === root.today.getDate() &&
                                    root.month === root.today.getMonth() &&
                                    root.year === root.today.getFullYear())
                                    ? "#ffffff" : Qt.rgba(1, 1, 1, 0.65)
                            font.pixelSize: 10
                            font.weight: (index + 1 === root.today.getDate() &&
                                          root.month === root.today.getMonth() &&
                                          root.year === root.today.getFullYear())
                                          ? Font.Bold : Font.Normal
                        }
                    }
                }
            }
        }

        // Divider
        Rectangle {
            width: 1
            height: parent.height
            color: Qt.rgba(1, 1, 1, 0.08)
        }

        // Upcoming events
        Column {
            width: parent.width * 0.4
            spacing: 8

            Text {
                text: "Upcoming"
                color: "#ffffff"
                font.pixelSize: 12
                font.weight: Font.Bold
            }

            Repeater {
                model: [
                    { title: "Team standup", time: "10:00 AM", color: "#4ecdc4" },
                    { title: "Design review", time: "2:00 PM", color: "#ff6b6b" },
                    { title: "Gym session", time: "6:00 PM", color: "#45b7d1" },
                    { title: "Movie night", time: "8:00 PM", color: "#96ceb4" }
                ]

                Rectangle {
                    width: parent.width
                    height: 36
                    radius: 8
                    color: Qt.rgba(1, 1, 1, 0.05)

                    Row {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 8

                        Rectangle {
                            width: 3
                            height: parent.height
                            radius: 1.5
                            color: modelData.color
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 1

                            Text {
                                text: modelData.title
                                color: "#ffffff"
                                font.pixelSize: 10
                                font.weight: Font.Medium
                            }

                            Text {
                                text: modelData.time
                                color: Qt.rgba(1, 1, 1, 0.4)
                                font.pixelSize: 9
                            }
                        }
                    }
                }
            }
        }
    }
}
