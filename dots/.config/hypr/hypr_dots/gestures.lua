hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace",
})

hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = function()
        hl.exec_cmd("hyprctl eval 'overview()'")
    end,
})



hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
})

hl.config({
    gestures = {
        workspace_swipe_invert = false,
    },
})