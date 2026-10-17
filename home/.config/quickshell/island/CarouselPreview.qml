import QtQuick
import Quickshell
import "components"

// Sample-only carousel preview. It sends no desktop commands.
ShellRoot {
    id: preview
    property var samples: [
        {id:'study',title:'Study video',artist:'Learning channel',player:'YouTube · browser tab',art:Qt.resolvedUrl('tests/fixtures/cover.svg'),length:600,position:180,playing:true},
        {id:'music',title:'Evening playlist',artist:'Music channel',player:'YouTube · browser tab',art:Qt.resolvedUrl('tests/fixtures/wallpaper.svg'),length:240,position:90,playing:true}
    ]
    property var state: ({media:Object.assign({},samples[0],{players:samples})})
    function send() {}
    FloatingWindow {
        visible: true
        implicitWidth: 440; implicitHeight: 242
        color: '#202830'
        Item {
            id: canvas
            anchors.fill: parent
            Rectangle { x:14; y:14; width:412; height:214; radius:38; color:'#000000' }
            MediaCard { x:28; y:28; width:384; height:186; bridge:preview; swipeOffset:-198 }
        }
    }
    Timer {
        interval: 1000; running: true
        onTriggered: canvas.grabToImage(result => {
            result.saveToFile('/tmp/island-carousel-preview.png');
            Qt.quit();
        })
    }
}
