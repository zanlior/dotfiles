import QtQuick
import ".."

Item {
    id: root
    property real value: 0
    property real from: 0
    property real to: 100
    property string icon: ""
    property bool thin: false
    property real stepSize: 5
    property string accessibleName: icon || "Level"
    activeFocusOnTab: true
    function adjust(delta) {
        if (!enabled) return;
        sendTimer.stop();
        previewValue = Math.max(from, Math.min(to, shownValue + delta));
        previewing = true;
        moved(previewValue);
        settleTimer.restart();
    }
    Keys.onLeftPressed: adjust(-stepSize)
    Keys.onDownPressed: adjust(-stepSize)
    Keys.onRightPressed: adjust(stepSize)
    Keys.onUpPressed: adjust(stepSize)
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Home) { adjust(from - shownValue); event.accepted = true; }
        else if (event.key === Qt.Key_End) { adjust(to - shownValue); event.accepted = true; }
    }
    property real previewValue: value
    property bool previewing: false
    readonly property real shownValue: previewing ? previewValue : value
    onValueChanged: {
        // Late hardware replies must not pull the slider back during a drag.
        if (!dragArea.pressed && Math.abs(value - previewValue) <= (to - from) / 100) {
            previewing = false;
            settleTimer.stop();
        }
    }
    signal moved(real value)
    implicitHeight: thin ? 18 : 28
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: root.thin ? 5 : parent.height
        radius: height / 2
        color: Qt.darker(Style.panel, 1.45)
        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, (root.shownValue - root.from) / Math.max(1, root.to - root.from)))
            height: parent.height
            radius: height / 2
            color: Style.accent
        }
    }
    Icon {
        x: 12
        anchors.verticalCenter: parent.verticalCenter
        name: root.icon
        visible: !!root.icon && !root.thin
        width: 16
        height: 16
        color: (root.shownValue - root.from) / Math.max(1, root.to - root.from) * root.width >= x + width ? Style.bg : Style.text
    }
    MouseArea {
        id: dragArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        function update(x) {
            root.previewValue = root.from + Math.max(0, Math.min(1, x / width)) * (root.to - root.from);
            root.previewing = true;
            if (!sendTimer.running)
                sendTimer.start();
        }
        onPressed: m => { root.forceActiveFocus(); update(m.x); }
        onPositionChanged: m => {
            if (pressed)
                update(m.x);
        }
        onReleased: {
            sendTimer.stop();
            root.moved(root.previewValue);
            settleTimer.restart();
        }
        onWheel: w => {
            root.adjust(w.angleDelta.y > 0 ? root.stepSize : -root.stepSize);
        }
    }
    Timer {
        id: sendTimer
        interval: 100
        onTriggered: root.moved(root.previewValue)
    }
    Timer {
        id: settleTimer
        interval: 5000
        onTriggered: root.previewing = false
    }
    Accessible.role: Accessible.Slider
    Accessible.name: accessibleName
    Accessible.description: Math.round(shownValue) + " (" + from + "–" + to + ")"
    Accessible.onIncreaseAction: adjust(stepSize)
    Accessible.onDecreaseAction: adjust(-stepSize)
}
