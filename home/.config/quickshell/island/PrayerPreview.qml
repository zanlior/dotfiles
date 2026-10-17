import QtQuick
import Quickshell
import "."
import "components"
import "tests/fixtures/PrayerFixture.js" as Fixture

ShellRoot {
    id: preview
    property var state: ({prayers: Fixture.data})
    // A fixed time makes the API fixture reproducible; the live panel uses the system clock.
    property date previewTime: new Date('2026-10-04T15:12:21+04:00')
    FloatingWindow {
        visible: true
        implicitWidth: 1080; implicitHeight: 510
        color: '#16302a'
        Item {
            id: canvas
            anchors.fill: parent
            Rectangle {
                id: frame
                anchors.centerIn: parent
                width: 960; height: 420
                color: Style.bg; radius: 24
                PrayerPanel {
                    anchors.fill: parent; anchors.margins: 16
                    bridge: preview; now: preview.previewTime
                }
            }
        }
        Timer {
            interval: 1200; running: true
            onTriggered: frame.grabToImage(result => {
                result.saveToFile('/tmp/island-prayer-preview.png');
                Qt.quit();
            })
        }
    }
}
