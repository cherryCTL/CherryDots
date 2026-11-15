local vars = require("hypr_dots.variables")


-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ WINDOW MANAGEMENT                                                    │
-- ╰──────────────────────────────────────────────────────────────────────╯

hl.bind(vars.mainMod .. " + x", hl.dsp.window.pseudo())
hl.bind(vars.mainMod .. " + C", hl.dsp.layout("togglesplit"))
hl.bind(vars.mainMod .. " + B", hl.dsp.layout("colresize +conf"))
hl.bind(vars.mainMod .. " + V", change_layouts)
hl.bind(vars.mainMod .. " + Q", hl.dsp.window.close())

hl.bind(
    vars.mainMod .. " + W",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    })
)

hl.bind(
    vars.mainMod .. " + SHIFT + W",
    hl.dsp.window.fullscreen_state({
        internal = 0,
        client = 2,
        action = "toggle",
    }),
    { locked = false }
)

hl.bind(
    vars.mainMod .. " + SHIFT + Z",
    hl.dsp.window.float({
        action = "toggle",
    })
)

hl.bind("SUPER + z", function()
    local w = hl.get_active_window()
    if w == nil then return end
    local was_floating = w.floating
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    if not was_floating then
        hl.dispatch(hl.dsp.window.resize({ x = 1280, y = 720 }))
        hl.dispatch(hl.dsp.window.center())
    end
end)

-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ FOCUS                                                                │
-- ╰──────────────────────────────────────────────────────────────────────╯

-- Arrow keys
hl.bind(vars.mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(vars.mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(vars.mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Vim keys
hl.bind(vars.mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(vars.mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(vars.mainMod .. " + j", hl.dsp.focus({ direction = "down" }))


-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ MOVE WINDOWS                                                         │
-- ╰──────────────────────────────────────────────────────────────────────╯

-- Arrow keys
hl.bind(
    vars.mainMod .. " + SHIFT + left",
    hl.dsp.window.move({ direction = "left" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + right",
    hl.dsp.window.move({ direction = "right" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + up",
    hl.dsp.window.move({ direction = "up" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + down",
    hl.dsp.window.move({ direction = "down" })
)

-- Vim keys
hl.bind(
    vars.mainMod .. " + SHIFT + h",
    hl.dsp.window.move({ direction = "left" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + l",
    hl.dsp.window.move({ direction = "right" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + k",
    hl.dsp.window.move({ direction = "up" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + j",
    hl.dsp.window.move({ direction = "down" })
)


-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ RESIZE WINDOWS                                                       │
-- ╰──────────────────────────────────────────────────────────────────────╯

-- Arrow keys
hl.bind(
    vars.mainMod .. " + CTRL + left",
    hl.dsp.window.resize({ x = -100, y = 0, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + right",
    hl.dsp.window.resize({ x = 100, y = 0, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + up",
    hl.dsp.window.resize({ x = 0, y = -100, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + down",
    hl.dsp.window.resize({ x = 0, y = 100, relative = true })
)

-- Vim keys
hl.bind(
    vars.mainMod .. " + CTRL + h",
    hl.dsp.window.resize({ x = -100, y = 0, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + l",
    hl.dsp.window.resize({ x = 100, y = 0, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + k",
    hl.dsp.window.resize({ x = 0, y = -100, relative = true })
)

hl.bind(
    vars.mainMod .. " + CTRL + j",
    hl.dsp.window.resize({ x = 0, y = 100, relative = true })
)


-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ WORKSPACES                                                           │
-- ╰──────────────────────────────────────────────────────────────────────╯

for i = 1, 10 do
    local key = i % 10

    hl.bind(
        vars.mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i })
    )

    hl.bind(
        vars.mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i })
    )
end

-- Scroll through existing workspaces
hl.bind(
    vars.mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    vars.mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" })
)

-- Cycle through open windows
hl.bind(
    vars.mainMod .. " + SHIFT + mouse_down",
    hl.dsp.focus({ direction = "right" })
)

hl.bind(
    vars.mainMod .. " + SHIFT + mouse_up",
    hl.dsp.focus({ direction = "left" })
)

hl.bind(
    vars.mainMod .. "+ CTRL + ALT + j",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    vars.mainMod .. "+ CTRL + ALT + K",
    hl.dsp.focus({ workspace = "e-1" })
)

hl.bind(
    vars.mainMod .. "+ CTRL + ALT + down",
    hl.dsp.focus({ workspace = "e+1" })
)

hl.bind(
    vars.mainMod .. "+ CTRL + ALT + up",
    hl.dsp.focus({ workspace = "e-1" })
)


-- ╭──────────────────────────────────────────────────────────────────────╮
-- │ MOUSE                                                                  │
-- ╰──────────────────────────────────────────────────────────────────────╯

hl.bind(
    vars.mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    vars.mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)

