import QtQuick
import ".."
Rectangle {
    id: root
    property bool checked: false
    property string accessibleName: "Toggle"
    activeFocusOnTab: true
    function activate() { if (enabled) toggled(!checked); }
    Keys.onSpacePressed: event => { if (!event.isAutoRepeat) activate(); }
    signal toggled(bool value)
    implicitWidth: 44; implicitHeight: 24; radius: 12
    color: checked ? Style.accent : Style.card
    Rectangle { x: root.checked ? root.width - width - 3 : 3; y: 3; width: root.height - 6; height: width; radius: width / 2; color: root.checked ? Style.bg : Style.muted; Behavior on x { NumberAnimation { duration: Style.settings.reduceMotion ? 0 : 150 } } }
    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { root.forceActiveFocus(); root.activate(); } }
    Accessible.role: Accessible.CheckBox; Accessible.name: accessibleName; Accessible.onPressAction: activate(); Accessible.checked: checked
}
