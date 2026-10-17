--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- ── Suppress maximize events (all windows) ───────────────────────────────────
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ── Fix XWayland phantom drag windows ────────────────────────────────────────
hl.window_rule({
    name         = "fix-xwayland-drags",
    match        = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- ── hyprland-run ─────────────────────────────────────────────────────────────
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = { "20", "monitor_h-120" },
    float = true,
})

-- ── MPV: always float, small ──────────────────────────────────────────────────
hl.window_rule({
    name   = "float-mpv",
    match  = { class = "^(mpv)$" },
    float  = true,
    opaque = true,
    size   = { 640, 360 },
    center = true,
})

-- ── PrismLauncher ────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "PrismLauncher",
    match  = { class = "org.prismlauncher.PrismLauncher" },
    float  = true,
    size   = { 700, 509 },
    center = true,
})

-- ── Minecraft game window ─────────────────────────────────────────────────────
hl.window_rule({
    name   = "Minecraft",
    match  = { class = "com.mojang.minecraft.java-edition" },
    opaque = true,
})

-- ── Steam: general (float + opaque) ──────────────────────────────────────────
hl.window_rule({
    name   = "steam-general",
    match  = { class = "^(steam)$" },
    float  = true,
    opaque = true,
})

-- ── Steam: main window ────────────────────────────────────────────────────────
hl.window_rule({
    name   = "steam-main-window",
    match  = { class = "^(steam)$", title = "^(Steam)$" },
    size   = { 1100, 600 },
    center = true,
})

-- ── Steam: friends list ───────────────────────────────────────────────────────
hl.window_rule({
    name  = "steam-friends",
    match = { class = "^(steam)$", title = "^(Friends List)$" },
    size  = { 460, 580 },
})

-- ── Steam: idle inhibit ───────────────────────────────────────────────────────
hl.window_rule({
    name          = "steam-idle",
    match         = { class = "^(steam)$" },
    idle_inhibit  = "fullscreen",
})

-- ── Show Me The Key ───────────────────────────────────────────────────────────
hl.window_rule({
    name        = "showmethekey-floating",
    match       = {
        class = "^(showmethekey-gtk)$",
        title = "^(Floating Window - Show Me The Key)$",
    },
    float       = true,
    pin         = true,
    size        = { 470, 50 },
    move        = { "((monitor_w-window_w)/2)", "(monitor_h-window_h-20)" },
    no_dim      = true,
    border_size = 0,
    opaque      = true,
})

-- ── GNOME Clocks ──────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-clocks",
    match  = { class = "^(org.gnome.clocks)$" },
    float  = true,
    size   = { 602, 297 },
    center = true,
})

-- ── GParted ───────────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "gparted",
    match  = { class = "^(GParted)$" },
    float  = true,
    size   = { 652, 431 },
    center = true,
})

-- ── Kew ───────────────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "kew",
    match  = { class = "^(kew)$" },
    float  = true,
    size   = { 652, 576 },
    center = true,
})

-- ── Thunar rename dialog ──────────────────────────────────────────────────────
hl.window_rule({
    name  = "float-thunar-rename",
    match = { class = "Thunar", title = "^Rename.*$" },
    float = true,
})

-- ── NWG Look ──────────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-nwg-look",
    match  = { class = "^(nwg-look)$" },
    float  = true,
    size   = { 627, 464 },
    center = true,
})

-- ── Kvantum Manager ───────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-kvantum",
    match  = { class = "^(kvantummanager)$" },
    float  = true,
    size   = { 585, 512 },
    center = true,
})

-- ── Qt6ct ─────────────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-qt6ct",
    match  = { class = "^(qt6ct)$" },
    float  = true,
    size   = { 700, 609 },
    center = true,
})

-- ── Qt5ct ─────────────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-qt5ct",
    match  = { class = "^(qt5ct)$" },
    float  = true,
    size   = { 636, 665 },
    center = true,
})

-- ── Pavucontrol ───────────────────────────────────────────────────────────────
hl.window_rule({
    name   = "float-pavucontrol",
    match  = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
    float  = true,
    size   = { 643, 422 },
    center = true,
})

-- ── Network Connection Editor ─────────────────────────────────────────────────
hl.window_rule({
    name   = "float-nm-editor",
    match  = { class = "^(nm-connection-editor)$" },
    float  = true,
    size   = { 432, 423 },
    center = true,
})

-- ── Picture-in-Picture ────────────────────────────────────────────────────────
hl.window_rule({
    name   = "pip-global",
    match  = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float  = true,
    pin    = true,
    size   = { 248, 140 },
    move   = { "(monitor_w-window_w-20)", "(monitor_h-window_h-20)" },
    no_dim = true,
    opaque = true,
})

-- ── Pinned window styling ─────────────────────────────────────────────────────
hl.window_rule({
    name         = "style-pinned-windows",
    match        = { pin = true },
    no_dim       = true,
    border_color = "rgb(328E6E)",
    border_size  = 2,
    animation    = "slide left",
})

-- ── Global: persistent size for floating windows ──────────────────────────────
hl.window_rule({
    name             = "global-persistent-size",
    match            = { float = true },
    persistent_size  = true,
})

-- ── Global: suppress maximize (duplicate of first rule, kept for clarity) ─────
hl.window_rule({
    name           = "global-suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- ── XWayland phantom window fix ───────────────────────────────────────────────
hl.window_rule({
    name       = "fix-xwayland-phantom",
    match      = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- ── Fullscreen window styling ──────────────────────────────────────────────────
hl.window_rule({
    name         = "style-fullscreen",
    match        = { fullscreen = true },
    border_color = "rgb(E2971F)",
    border_size  = 4,
    rounding     = 0,
})

-- ── Common dialogs (title-based) ──────────────────────────────────────────────
hl.window_rule({
    name   = "float-dialogs-title",
    match  = {
        title = "^(Open|Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library|File Upload|Authentication Required|Add Folder to Workspace|Choose Files|Confirm to replace files|File Operation Progress)(.*)$|^(.*dialog.*)$",
    },
    float  = true,
    center = true,
    size   = { 816, 537 },
})

-- ── Common dialogs (class-based) ──────────────────────────────────────────────
hl.window_rule({
    name   = "float-dialogs-class",
    match  = { class = "^(org.gnome.FileRoller|[Xx]dg-desktop-portal-gtk|.*dialog.*)$" },
    float  = true,
    center = true,
    size   = { 816, 537 },
})

-- ── Thunar: slight transparency ───────────────────────────────────────────────
hl.window_rule({
    name    = "thunar-blur",
    match   = { class = "^(thunar|Thunar)$" },
    opacity = "0.92",
})

hl.layer_rule({
    name    = "rofi-popup",
    match   = { namespace = "rofi" },
    animation = "slide bottom",
    dim_around = true
})

hl.layer_rule({
    name    = "notification-animations",
    match   = { namespace = "swaync-control-center" },
    animation = "slide top",
})