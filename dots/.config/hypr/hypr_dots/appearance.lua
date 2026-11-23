
local appearances = {

    -- 1. NORMAL
    {
        name = "Normal",
        config = {
            general = {
                border_size = 2,
                gaps_in = 2,
                gaps_out = 8,
            },
            decoration = {
                wobble = {
                    enabled = false,
                },
                active_opacity = 1.0,
                inactive_opacity = 0.98,
                fullscreen_opacity = 1.0,
                rounding = 8,
                rounding_power = 3,

                shadow = {
                    enabled = false,
                    range = 2,
                    render_power = 4,
                },

                blur = {
                    enabled = true,
                    variant = "kawase",
                    size = 4,
                    passes = 2,
                    noise = 0.01,
                    contrast = 1.05,
                    brightness = 1.04,
                    vibrancy = 0.18,
                    vibrancy_darkness = 0.12,
                    ignore_opacity = true,
                    new_optimizations = true,
                    xray = false,
                    popups = true,
                    special = true,
                },
            },
        },
    },

    -- 2. PERFORMANCE
    {
        name = "Performance",
        config = {
            general = {
                border_size = 1,
                gaps_in = 2,
                gaps_out = 2,
            },
            decoration = {
                active_opacity = 1.0,
                inactive_opacity = 1.0,
                fullscreen_opacity = 1.0,

                rounding = 0,
                rounding_power = 2,

                shadow = {
                    enabled = false,
                    range = 0,
                    render_power = 1,
                },

                glow = {
                    enabled = false,
                },

                wobble = {
                    enabled = false,
                },

                motion_blur = {
                    enabled = false,
                },

                blur = {
                    enabled = false,
                    variant = "kawase",
                    size = 1,
                    passes = 1,
                    noise = 0.0,
                    contrast = 1.0,
                    brightness = 1.0,
                    vibrancy = 0.0,
                    vibrancy_darkness = 0.0,
                    ignore_opacity = false,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,
                },
            },
        },
    },

    -- 3. SILK
    {
        name = "Silk",
        config = {
            general = {
                border_size = 2,
                gaps_in = 7,
                gaps_out = 11,
            },
            decoration = {
                wobble = {
                    enabled = false,
                },
                active_opacity = 0.92,
                inactive_opacity = 0.90,
                fullscreen_opacity = 1.0,
                rounding = 14,
                rounding_power = 4,

                shadow = {
                    enabled = false,
                },

                blur = {
                    enabled = true,
                    variant = "kawase",
                    size = 2,
                    passes = 1,
                    noise = 0.008,
                    contrast = 1.05,
                    brightness = 1.03,
                    vibrancy = 0.16,
                    vibrancy_darkness = 0.12,
                    ignore_opacity = false,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,

                },
            },
        },
    },

    -- 4. RUSH
    {
        name = "Rush",
        config = {
            general = {
                border_size = 2,
                gaps_in = 9,
                gaps_out = 14,
            },
            decoration = {
                wobble = {
                    enabled = false,
                },
                active_opacity = 0.97,
                inactive_opacity = 0.89,
                fullscreen_opacity = 1.0,
                rounding = 14,
                rounding_power = 4,

                shadow = {
                    enabled = false,
                },

                blur = {
                    enabled = true,
                    variant = "aurora",
                    size = 5,
                    passes = 2,
                    noise = 0.018,
                    contrast = 1.18,
                    brightness = 1.08,
                    vibrancy = 0.62,
                    vibrancy_darkness = 0.30,
                    ignore_opacity = true,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,

                    aurora = {
                        color1 = 0x00D5FFCC,
                        color2 = 0xB44AFFFF,
                        intensity = 0.48,
                        speed = 0.85,
                    },
                },
            },
        },
    },

    -- 5. LUMEN
    {
        name = "Lumen",
        config = {
            general = {
                border_size = 2,
                gaps_in = 5,
                gaps_out = 8,
            },
            decoration = {
                wobble = {
                    enabled = false,
                },
                active_opacity = 0.98,
                inactive_opacity = 0.95,
                fullscreen_opacity = 1.0,
                rounding = 8,
                rounding_power = 3,

                shadow = {
                    enabled = false,
                },

                blur = {
                    enabled = true,
                    variant = "kawase",
                    size = 3,
                    passes = 1,
                    noise = 0.008,
                    contrast = 1.10,
                    brightness = 1.08,
                    vibrancy = 0.25,
                    vibrancy_darkness = 0.12,
                    ignore_opacity = true,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,
                },
            },
        },
    },

    -- 6. ARCTIC
    {
        name = "Arctic",
        config = {
            general = {
                border_size = 2,
                gaps_in = 6,
                gaps_out = 10,
            },
            decoration = {
                wobble = {
                    enabled = false,
                },
                active_opacity = 0.95,
                inactive_opacity = 0.90,
                fullscreen_opacity = 1.0,
                rounding = 16,
                rounding_power = 4,

                shadow = {
                    enabled = false,
                },

                blur = {
                    enabled = true,
                    variant = "frost",
                    size = 4,
                    passes = 2,
                    noise = 0.015,
                    contrast = 1.12,
                    brightness = 1.07,
                    vibrancy = 0.22,
                    vibrancy_darkness = 0.25,
                    ignore_opacity = true,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,
                },
            },
        },
    },

    -- 7. JIGGLE
    {
        name = "Jiggle",
        config = {
            general = {
                border_size = 2,
                gaps_in = 8,
                gaps_out = 12,
            },
            decoration = {
                -- Native Hyprland Compiz-style elastic window deformation.
                -- Elastic spring with a stronger but controlled wobble.
                wobble = {
                    enabled = true,
                    mesh = 14,
                    stiffness = 160.0,
                    damping = 7.2,
                    mass = 1.2,
                    intensity = 0.40,
                    value_epsilon = 0.20,
                    velocity_epsilon = 1.6,
                },
                active_opacity = 0.96,
                inactive_opacity = 0.92,
                fullscreen_opacity = 1.0,
                rounding = 12,
                rounding_power = 4,

                shadow = {
                    enabled = false,
                },

                blur = {
                    enabled = true,
                    variant = "prism",
                    size = 3,
                    passes = 1,
                    noise = 0.012,
                    contrast = 1.10,
                    brightness = 1.06,
                    vibrancy = 0.38,
                    vibrancy_darkness = 0.18,
                    ignore_opacity = true,
                    new_optimizations = true,
                    xray = false,
                    popups = false,
                    special = false,

                    glass = {
                        refraction = 11.0,
                        roughness = 0.48,
                        size = 56.0,
                    },
                },
            },
        },
    },
}

-- ============================================================
-- APPEARANCE MODULE API
-- The switcher and keybinds live in shortcuts_system.lua.
-- ============================================================

local M = {}
local profiles_by_name = {}

for _, profile in ipairs(appearances) do
    profiles_by_name[string.lower(profile.name)] = profile
    if profile.label then
        profiles_by_name[string.lower(profile.label)] = profile
    end
end

function M.apply(name)
    if type(name) ~= "string" then
        return false, "Appearance name must be a string"
    end

    local profile = profiles_by_name[string.lower(name)]
    if not profile then
        return false, "Unknown appearance: " .. name
    end

    local ok, err = pcall(hl.config, profile.config)
    if not ok then
        return false, tostring(err)
    end

    return true, profile.label or profile.name
end

function M.names()
    local result = {}
    for index, profile in ipairs(appearances) do
        result[index] = profile.label or profile.name
    end
    return result
end

return M
