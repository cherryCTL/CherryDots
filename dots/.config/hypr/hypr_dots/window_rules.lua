-- Ignore maximize requests from all apps.
local suppressMaximizeRule = hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },

    suppress_event = "maximize",
})



-- Fix some dragging issues with XWayland
hl.window_rule({
    name = "fix-xwayland-drags",

    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Hyprland-run window rule
hl.window_rule({
    name = "move-hyprland-run",
    match = {
        class = "hyprland-run",
    },

    move  = "20 monitor_h-120",
    float = true,
})



hl.window_rule({
    name = "ab-download-manager",
    match = {
        class = "^com-abdownloadmanager-desktop-AppKt$",
    },
    float = true,
    center = true,
})

hl.window_rule({
    name = "telegram-media-viewer",
    match = {
        class = "^org\\.telegram\\.desktop$",
        title = "^Media viewer$",
    },
    float = true,
    size = "900 900",
})


hl.window_rule({
    match = { class = "brave-origin" },
    opacity = "1.0 override 1.0 override",
})

hl.window_rule({
    match = { class = "codium" },
    opacity = "1.0 override 1.0 override",
})

hl.window_rule({
    match = { class = "mpv" },
    opacity = "1.0 override 1.0 override",
    
})

hl.window_rule({
    match = { class = "scrcpy" },
    opacity = "1.0 override 1.0 override",
    fullscreen = false,
    float = true,
    move = "1574 305",
    min_size = {340, 768},
    max_size = {340, 768},
})

hl.window_rule({
    name = "wobble-only-floating",

    match = {
        float = false,
    },

    no_wobble = true,
})