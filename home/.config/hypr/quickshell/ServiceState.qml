import QtQuick

// Stable service properties prevent unrelated backend updates from invalidating consumers.
QtObject {
    property var audio
    property var bluetooth
    property var busy
    property var busyCommands
    property var capabilities
    property var clipboard
    property var desktop
    property var display
    property var media
    property var monitorConfirm
    property var nightActive
    property var pairing
    property var prayerAudio
    property var prayers
    property var wallpaperSelected
    property var wallpapers
    property var wifi
    readonly property var serviceKeys: [
        'audio', 'bluetooth', 'busy', 'busyCommands', 'capabilities', 'clipboard',
        'desktop', 'display', 'media', 'monitorConfirm', 'nightActive', 'pairing',
        'prayerAudio', 'prayers', 'wallpaperSelected', 'wallpapers', 'wifi'
    ]
    function apply(update) {
        for (const key of Object.keys(update)) {
            if (serviceKeys.includes(key)) this[key] = update[key];
        }
    }
}
