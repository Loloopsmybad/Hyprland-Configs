import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property string widgetName
    property real posX: 100
    property real posY: 100
    property real widgetWidth: 200
    property real widgetHeight: 200

    WlrLayershell.namespace: `liquidglass-${widgetName}`
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    anchors.top: true
    anchors.left: true
    margins.top: root.posY
    margins.left: root.posX
    exclusiveZone: -1
    implicitWidth: root.widgetWidth
    implicitHeight: root.widgetHeight

    default property alias content: contentArea.data

    Item {
        id: contentArea
        anchors.fill: parent
    }
}
