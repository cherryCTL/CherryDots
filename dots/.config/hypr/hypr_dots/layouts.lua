-- Layouts used by the layout switcher
local layouts = {
    "dwindle",
    "scrolling",
    
}

local current = 1

change_layouts = function()
    current = current + 1

    if current > #layouts then
        current = 1
    end

    local layout = layouts[current]
    

    hl.config({
        general = {
            layout = layout
        }
    })
end

-- Scrolling layout
hl.config({
    scrolling = {
        fullscreen_on_one_column = false,
        column_width = 0.98,
    },
})

-- Dwindle layout
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- Master layout
hl.config({
    master = {
        new_status = "master",
    },
})

