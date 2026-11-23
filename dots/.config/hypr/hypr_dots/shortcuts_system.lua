
local vars = require("hypr_dots.variables")



hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%-"),
    { locked = true, repeating = true }
)


hl.bind(
    vars.mainMod .. " + F1",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + F2",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + SHIFT + F2",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + F3",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + SHIFT + F3",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + F4",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + F5",
    hl.dsp.exec_cmd("brightnessctl set 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + F6",
    hl.dsp.exec_cmd("brightnessctl set 5%+"),
    { locked = true, repeating = true }
)



hl.bind(
    vars.mainMod .. " + F8",
    hl.dsp.exec_cmd(vars.lock_screen),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + SHIFT + F8",
    hl.dsp.exec_cmd(vars.power),
    { locked = true }
)


hl.bind(
    vars.mainMod .. " + F9",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + F10",
    hl.dsp.exec_cmd("playerctl stop"),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + F11",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + F12",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    vars.mainMod .. " + SHIFT + F12",
    hl.dsp.exec_cmd("playerctl position 10+"),
    { locked = true, repeating = true }
)

hl.bind(
    vars.mainMod .. " + SHIFT + F11",
    hl.dsp.exec_cmd("playerctl position 10-"),
    { locked = true, repeating = true }
)



hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { locked = true }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { locked = true }
)

hl.bind(
    "SHIFT + XF86AudioNext",
    hl.dsp.exec_cmd("playerctl position 10+"),
    { locked = true, repeating = true }
)

hl.bind(
    "SHIFT + XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl position 10-"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true }
)



hl.bind(
    vars.mainMod .. " + CTRL+ f8",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
    )
)

-- ============================================================
-- APPEARANCE + ANIMATION PROFILE SWITCHER
-- Kept in shortcuts_system.lua; all original system shortcuts above remain.
-- ============================================================

local appearance_profiles = require("hypr_dots.appearance")
local animation_profiles = require("hypr_dots.animations")

if type(appearance_profiles) ~= "table" or type(appearance_profiles.apply) ~= "function" then
    error("hypr_dots.appearance must return a module table with apply(name)")
end

if type(animation_profiles) ~= "table" or type(animation_profiles.apply) ~= "function" then
    error("hypr_dots.animations must return a module table with apply(name)")
end

local appearance_order = {
    "normal",
    "silk",
    "lumen",
    "rush",
    "jiggle",
    "arctic",
    "performance",
}

local current_appearance_index = 1

local function appearance_notify(message, icon, timeout)
    hl.notification.create({
        text = message,
        timeout = timeout or 1800,
        icon = icon or "info",
        font_size = 16,
    })
end

local function apply_appearance_profile(index, show_notification)
    local profile_name = appearance_order[index]
    if not profile_name then
        return false
    end

    local app_call_ok, app_ok, app_result = pcall(appearance_profiles.apply, profile_name)
    if not app_call_ok then
        appearance_notify("Appearance error: " .. tostring(app_ok), "err", 3500)
        return false
    end
    if not app_ok then
        appearance_notify("Appearance error: " .. tostring(app_result), "err", 3500)
        return false
    end

    local anim_call_ok, anim_ok, anim_result = pcall(animation_profiles.apply, profile_name)
    if not anim_call_ok then
        appearance_notify("Animation error: " .. tostring(anim_ok), "err", 3500)
        return false
    end
    if not anim_ok then
        appearance_notify("Animation error: " .. tostring(anim_result), "err", 3500)
        return false
    end

    if show_notification then
        appearance_notify("Appearance: " .. tostring(app_result or profile_name), "info", 1800)
    end

    return true
end

local function cycle_appearance(direction)
    local next_index = ((current_appearance_index - 1 + direction) % #appearance_order) + 1

    if apply_appearance_profile(next_index, true) then
        current_appearance_index = next_index
    end
end

-- Start in Normal when the Hyprland config is loaded.
if not apply_appearance_profile(current_appearance_index, false) then
    appearance_notify("Could not initialize the Normal profile", "warn", 3500)
end

-- Next profile: Super + N
hl.bind(vars.mainMod .. " + N", function()
    cycle_appearance(1)
end)

-- Previous profile: Super + Shift + N
hl.bind(vars.mainMod .. " + SHIFT + N", function()
    cycle_appearance(-1)
end)

