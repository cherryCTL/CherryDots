
require("hypr_dots.variables")
require("hypr_dots.workspaces")
require("hypr_dots.monitors")
require("hypr_dots.autostart")
require("hypr_dots.environment")
require("hypr_dots.appearance")
require("hypr_dots.layouts")
require("hypr_dots.animations")
require("hypr_dots.input")
require("hypr_dots.gestures")
require("hypr_dots.plugins")
require("hypr_dots.shortcuts_apps")
require("hypr_dots.shortcuts_window")
require("hypr_dots.shortcuts_system")
require("hypr_dots.window_rules")
require("hypr_dots.shortcuts_browser")

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
})




-- For Noctalia Color templates
require("noctalia").apply_theme()
