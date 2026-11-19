local vars = require("hypr_dots.variables")



hl.bind(
    vars.mainMod .. " + F7",
    hl.dsp.exec_cmd("noctalia")
)

hl.bind(
    "Insert",
    hl.dsp.exec_cmd(vars.colorpicker)
)



hl.bind(
    vars.mainMod .. " + R",
    hl.dsp.exec_cmd(vars.fileManager)
)

hl.bind(
    vars.mainMod .. " + SHIFT + r",
    hl.dsp.exec_cmd(vars.fileManager2)
)

hl.bind(
    vars.mainMod .. " + CTRL + r",
    hl.dsp.exec_cmd(vars.KillFilemanager2)
)

hl.bind(
    vars.mainMod .. " + A",
    hl.dsp.exec_cmd(vars.menu_luncher)
)

hl.bind(
    vars.mainMod .. " + D",
    hl.dsp.exec_cmd(vars.terminal)
)

hl.bind(
    vars.mainMod .. " + SHIFT + D",
    hl.dsp.exec_cmd(vars.terminal2)
)

hl.bind(
    vars.mainMod .. " + S",
    hl.dsp.exec_cmd(vars.browser)
)

hl.bind(
    vars.mainMod .. " + CTRL + S",
    hl.dsp.exec_cmd(vars.browser_private)
)

hl.bind(
    vars.mainMod .. " + SHIFT + s",
    hl.dsp.exec_cmd(vars.browser2)
)

hl.bind(
    vars.mainMod .. " + CTRL + SHIFT + s",
    hl.dsp.exec_cmd(vars.browser2_private)
)

hl.bind(
    vars.mainMod .. " + g",
    hl.dsp.exec_cmd(vars.gameEngine)
)

hl.bind(
    vars.mainMod .. " + f",
    hl.dsp.exec_cmd(vars.editor)
)

hl.bind(
    "CTRL + SHIFT + ESCAPE",
    hl.dsp.exec_cmd(vars.SystemMonitor)
)

hl.bind(
    vars.mainMod .. " + u",
    hl.dsp.exec_cmd(vars.SystemUpdate)
)

hl.bind(
    vars.mainMod .. " + GRAVE",
    hl.dsp.exec_cmd(vars.emoji_picker)
)

hl.bind(
    vars.mainMod .. " + SHIFT + GRAVE",
    hl.dsp.exec_cmd(vars.emoji_picker2)
)

hl.bind(
    "Print",
    hl.dsp.exec_cmd(vars.screenshot1)
)

hl.bind(
    "SHIFT + Print",
    hl.dsp.exec_cmd(vars.screenshot2)
)

hl.bind(
    "XF86PowerOff",
    hl.dsp.exec_cmd(vars.power)
)

hl.bind(
    vars.mainMod .. " + SHIFT + p ",
    hl.dsp.exec_cmd(vars.power)
)

hl.bind(
    vars.mainMod .. " + i",
    hl.dsp.exec_cmd(vars.setting)
)

hl.bind(
    vars.mainMod .. " + m",
    hl.dsp.exec_cmd(vars.wallpaper_menu)
)

hl.bind(
    vars.mainMod .. " + comma",
    hl.dsp.exec_cmd(vars.wallpaper_next)
)

hl.bind(
    vars.mainMod .. " + period",
    hl.dsp.exec_cmd(vars.wallpaper_prev)
)

hl.bind(
    vars.mainMod .. " + slash",
    hl.dsp.exec_cmd(vars.wallpaper_rand)
)


hl.bind(
    vars.mainMod .. " + P",
    hl.dsp.exec_cmd(vars.power_profile)
)