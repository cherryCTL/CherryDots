local M = require("hypr_dots.variables")

local binds = {}

local function command_name(command)
    if not command then
        return nil
    end

    local app = command:match("([%w_.%-]+)%.appimage")
        or command:match("([%w_.%-]+)%s*$")

    if app then
        return app:lower()
    end

    return nil
end

local function matches_browser(window)
    if not window or not window.class then
        return false
    end

    local class = window.class:lower()
    local commands = { M.browser, M.browser2 }

    for _, command in ipairs(commands) do
        local name = command_name(command)

        if name and (
            class == name
            or class:find(name, 1, true)
            or name:find(class, 1, true)
        ) then
            return true
        end
    end

    return false
end

local function bind_browser(key, extra_mods, target_mods, target_key)
    local modifiers = M.secendMod

    if extra_mods and extra_mods ~= "" then
        modifiers = modifiers .. " + " .. extra_mods
    end

    local handle = hl.bind(
        modifiers .. " + " .. key,
        function()
            if not matches_browser(hl.get_active_window()) then
                return
            end

            hl.dispatch(hl.dsp.send_shortcut({
                mods = target_mods,
                key = target_key,
                window = "activewindow",
            }))
        end
    )

    handle:set_enabled(false)
    table.insert(binds, handle)
end

-- Scroll
bind_browser("H", nil, "", "LEFT")
bind_browser("J", nil, "", "NEXT")
bind_browser("K", nil, "", "PRIOR")
bind_browser("L", nil, "", "RIGHT")

bind_browser("LEFT", nil, "", "LEFT")
bind_browser("DOWN", nil, "", "NEXT")
bind_browser("UP", nil, "", "PRIOR")
bind_browser("RIGHT", nil, "", "RIGHT")

-- Browser history
bind_browser("H", "SHIFT", "ALT", "LEFT")
bind_browser("L", "SHIFT", "ALT", "RIGHT")
bind_browser("LEFT", "SHIFT", "ALT", "LEFT")
bind_browser("RIGHT", "SHIFT", "ALT", "RIGHT")

-- Reload
bind_browser("R", nil, "", "F5")
bind_browser("R", "SHIFT", "CTRL SHIFT", "R")

-- Tabs
bind_browser("W", nil, "CTRL", "T")
bind_browser("Q", nil, "CTRL", "W")
bind_browser("Q", "SHIFT", "CTRL SHIFT", "T")

-- Focus tabs 1-8
for i = 1, 8 do
    local key = tostring(i)
    bind_browser(key, nil, "CTRL", key)
    bind_browser(key, "SHIFT", "CTRL", key)
end

-- Focus last tab
bind_browser("9", nil, "CTRL", "9")
bind_browser("9", "SHIFT", "CTRL", "9")

local function update_binds()
    local enabled = matches_browser(hl.get_active_window())

    for _, bind in ipairs(binds) do
        bind:set_enabled(enabled)
    end
end

hl.on("window.active", update_binds)
update_binds()

return M