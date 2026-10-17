-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        -- ── Gaps & Borders ────────────────────────────────────────────────
        gaps_in          = 6,
        gaps_out         = 12,
        gaps_workspaces  = 0,
        border_size      = 1,
 
        -- ── Colors ───────────────────────────────────────────────────────
        -- Replace these with your actual hex values from colors.conf
        col = {
            active_border   = "rgb(45403d)",
            inactive_border = "rgba(45403d99)",
            --active_border   = "$grey0",
            --inactive_border = "$bg1",
        },
 
        -- ── Behavior ─────────────────────────────────────────────────────
        resize_on_border = false,
        allow_tearing    = true,
 
        -- ── Snapping ─────────────────────────────────────────────────────
        snap = {
            enabled        = false,
            window_gap     = 10,
            monitor_gap    = 10,
            border_overlap = false,
        },
    },
 
    decoration = {
        -- ── Rounding ─────────────────────────────────────────────────────
        rounding       = 12,
        rounding_power = 6,
 
        -- ── Opacity ───────────────────────────────────────────────────────
        active_opacity     = 1.0,
        inactive_opacity   = 0.92,
        fullscreen_opacity = 1.0,
 
        -- ── Dimming ───────────────────────────────────────────────────────
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special  = 0.5,
 
        -- ── Shadows ───────────────────────────────────────────────────────
        shadow = {
            enabled      = false,
            range        = 35,
            render_power = 2,
            sharp        = false,
            -- ignore_window removed in 0.55 (now always true)
            scale        = 1.0,
            color        = 0x1a1a1aee,
        },
 
        -- ── Blur ──────────────────────────────────────────────────────────
        blur = {
            enabled           = false,
            size              = 4,
            passes            = 2,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
            noise             = 0.0117,
            contrast          = 0.8916,
            brightness        = 0.8172,
            vibrancy          = 0.1696,
            popups            = false,
        },
    },
 
    -- ── Dwindle layout ────────────────────────────────────────────────────────
    -- NOTE: pseudotile was removed in 0.55
    dwindle = {
        preserve_split = true,
    },
 
    -- ── Master layout ─────────────────────────────────────────────────────────
    master = {
        new_status = "master",
    },
 
    -- ── Misc ──────────────────────────────────────────────────────────────────
    misc = {
        force_default_wallpaper  = 1,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})
