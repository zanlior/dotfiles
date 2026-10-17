import QtQuick
import Quickshell
import "."
ShellRoot {
    id: preview
    property var notifications: []
    function clearNotifications() {}
    function dismiss(n) {}
    property var state: ({prayerAudio:{playing:false,configured:false,error:''}})
    function send(a,v,e) { console.log('PREVIEW',a); }
    FloatingWindow {
        visible:true;implicitWidth:1180;implicitHeight:1000;color:Style.bg
        Settings {id: settings; width:1180; height:1000; anchors.centerIn:parent; bridge:preview;section:'Prayer Times'}
        Timer {interval:1200;running:true;onTriggered:settings.grabToImage(r=>{r.saveToFile('/tmp/prayer-reminder-settings.png');Qt.quit();})}
    }
}
