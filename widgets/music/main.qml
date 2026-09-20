import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root
    anchors.fill: parent

    property var player: {
        for (let i = 0; i < Mpris.players.length; i++) {
            const p = Mpris.players[i]
            if (p.trackTitle !== "") return p
        }
        return null
    }

    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string album: player?.trackAlbum ?? ""
    readonly property string artUrl: player?.trackArtUrl ?? ""
    readonly property bool isPlaying: player?.isPlaying ?? false
    readonly property real position: player?.position ?? 0
    readonly property real length: player?.length ?? 0
    readonly property bool hasPlayer: player !== null

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

        // Album art
        Rectangle {
            width: 64
            height: 64
            radius: 12
            color: Qt.rgba(1, 1, 1, 0.05)
            clip: true
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: albumImage
                anchors.fill: parent
                source: root.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                text: "♫"
                font.pixelSize: 24
                color: Qt.rgba(1, 1, 1, 0.2)
                visible: !albumImage.visible
            }
        }

        // Info + controls
        Column {
            width: parent.width - 76
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            // Track info
            Text {
                width: parent.width
                text: root.hasPlayer ? (root.title || "Unknown track") : "No player"
                color: "#ffffff"
                font.pixelSize: 13
                font.weight: Font.Bold
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                width: parent.width
                text: root.hasPlayer ? (root.artist || "Unknown artist") : "Start playing music"
                color: Qt.rgba(1, 1, 1, 0.5)
                font.pixelSize: 11
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            // Progress bar
            Rectangle {
                width: parent.width
                height: 3
                radius: 1.5
                color: Qt.rgba(1, 1, 1, 0.1)

                Rectangle {
                    width: root.length > 0 ? (root.position / root.length) * parent.width : 0
                    height: parent.height
                    radius: parent.radius
                    color: Qt.rgba(1, 1, 1, 0.6)
                }
            }

            // Time labels
            Row {
                width: parent.width
                Text {
                    text: formatSec(root.position)
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.pixelSize: 9
                }
                Item { width: parent.width - 2 * 35; height: 1 }
                Text {
                    text: formatSec(root.length)
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.pixelSize: 9
                }
            }

            // Controls
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                // Previous
                Text {
                    text: "⏮"
                    font.pixelSize: 14
                    color: root.hasPlayer ? Qt.rgba(1, 1, 1, 0.6) : Qt.rgba(1, 1, 1, 0.2)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.hasPlayer ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.player?.previous()
                    }
                }

                // Play / Pause
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: root.hasPlayer ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.05)

                    Text {
                        anchors.centerIn: parent
                        text: root.isPlaying ? "⏸" : "▶"
                        color: root.hasPlayer ? "#ffffff" : Qt.rgba(1, 1, 1, 0.3)
                        font.pixelSize: 16
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.hasPlayer ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (!root.hasPlayer) return
                            if (root.isPlaying) root.player?.pause()
                            else root.player?.play()
                        }
                    }
                }

                // Next
                Text {
                    text: "⏭"
                    font.pixelSize: 14
                    color: root.hasPlayer ? Qt.rgba(1, 1, 1, 0.6) : Qt.rgba(1, 1, 1, 0.2)
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: root.hasPlayer ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.player?.next()
                    }
                }
            }
        }
    }

    function formatSec(s) {
        const m = Math.floor(s / 60)
        const sec = Math.floor(s % 60)
        return String(m).padStart(2, '0') + ":" + String(sec).padStart(2, '0')
    }
}
