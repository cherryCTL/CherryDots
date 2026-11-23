-- ============================================================
-- SAKURA ANIMATION PROFILES
-- Hyprland 0.57+ Lua API
-- Profiles are applied by shortcuts_system.lua.
-- ============================================================

local M = {}

-- ============================================================
-- GLOBAL WORKSPACE CONTROL
-- ============================================================
-- "vertical"   -> slidefadevert
-- "horizontal" -> slidefade
local WORKSPACE_DIRECTION = "vertical"

local function is_valid_direction(direction)
    return direction == "horizontal" or direction == "vertical"
end

assert(
    is_valid_direction(WORKSPACE_DIRECTION),
    'WORKSPACE_DIRECTION must be "horizontal" or "vertical"'
)

-- Workspace leaves all use one direction resolver. The style is generated
-- when a profile is applied, so every profile follows the same setting.
local workspace_leaves = {
    workspaces = true,
    workspacesIn = true,
    workspacesOut = true,
    specialWorkspace = true,
    specialWorkspaceIn = true,
    specialWorkspaceOut = true,
}

local function workspace_style(amount)
    local style = WORKSPACE_DIRECTION == "vertical" and "slidefadevert" or "slidefade"
    return style .. " " .. amount
end

-- Each appearance profile keeps its own spring parameters.
local function register_spring(name, stiffness, damping)
    hl.curve(name, {
        type = "spring",
        mass = 1.0,
        stiffness = stiffness,
        damping = damping,
    })
end

-- Custom curves are registered once when this module is required.
hl.curve("sakura_normal", {
    type = "bezier",
    points = { {0.22, 1.0}, {0.36, 1.0} },
})

-- Silk keeps its soft spring for window/layer motion, but uses a dedicated
-- ease-out curve for workspace transitions. This avoids the spring's long
-- settling tail while keeping the same easing at a 20% shorter duration (320 ms).
register_spring("sakura_silk", 180, 26)
hl.curve("sakura_silk_workspace", {
    type = "bezier",
    points = { {0.215, 0.61}, {0.355, 1.0} },
})

-- Rush: fast, controlled bezier motion with a crisp, energetic stop.
hl.curve("sakura_rush", {
    type = "bezier",
    points = { {0.16, 1.0}, {0.30, 1.0} },
})

-- Lumen: a gentle, polished curve with a measured start and soft finish.
-- Unlike Rush, it should feel composed rather than immediately accelerating.
hl.curve("sakura_lumen", {
    type = "bezier",
    points = { {0.25, 0.10}, {0.25, 1.0} },
})

-- Arctic: slightly overdamped and deliberately heavier, without becoming sluggish.
register_spring("sakura_arctic", 180, 27.5)

-- Jiggle: a more underdamped spring gives window movement a clearer elastic bounce.
register_spring("sakura_jiggle", 230, 20.5)

-- These are the animation leaves used by the current Hyprland animation tree.
local leaves = {
    "global",
    "windows", "windowsIn", "windowsOut", "windowsMove",
    "layers", "layersIn", "layersOut",
    "fade", "fadeIn", "fadeOut", "fadeSwitch", "fadeShadow",
    "fadeGlow", "fadeDim", "fadeLayers", "fadeLayersIn",
    "fadeLayersOut", "fadePopups", "fadePopupsIn", "fadePopupsOut",
    "fadeDpms",
    "border", "borderangle", "shadowangle", "glowangle",
    "workspaces", "workspacesIn", "workspacesOut",
    "specialWorkspace", "specialWorkspaceIn", "specialWorkspaceOut",
    "zoomFactor", "monitorAdded",
}

-- Animation speed is measured in deciseconds (1 = 100 ms).
-- workspace_distance is applied to every workspace leaf at runtime.
local profiles = {
    -- Performance disables every animation leaf explicitly.
    performance = {
        disabled = true,
        settings = {},
    },

    normal = {
        curve = "sakura_normal",
        kind = "bezier",
        speed = 3.0,
        workspace_distance = "12%",
        settings = {
            windows = { speed = 3.8, style = "popin 96%" },
            windowsIn = { speed = 3.4, style = "popin 96%" },
            windowsOut = { speed = 2.7, style = "popin 96%" },
            windowsMove = { speed = 2.8 },
            layers = { speed = 3.2, style = "fade" },
            layersIn = { speed = 3.2, style = "fade" },
            layersOut = { speed = 2.6, style = "fade" },
            border = { speed = 2.3 },
            zoomFactor = { speed = 2.8 },
            monitorAdded = { speed = 3.5 },
        },
    },

    silk = {
        curve = "sakura_silk",
        kind = "spring",
        workspace_curve = "sakura_silk_workspace",
        speed = 3.2,
        workspace_distance = "14%",
        settings = {
            windows = { speed = 3.2, style = "popin 94%" },
            windowsIn = { speed = 3.2, style = "popin 94%" },
            windowsOut = { speed = 2.56, style = "popin 94%" },
            windowsMove = { speed = 3.04 },
            layers = { speed = 3.2, style = "fade" },
            layersIn = { speed = 3.2, style = "fade" },
            layersOut = { speed = 2.56, style = "fade" },
            border = { speed = 2.24 },
            zoomFactor = { speed = 2.8 },
            monitorAdded = { speed = 3.04 },
        },
    },

    rush = {
        curve = "sakura_rush",
        kind = "bezier",
        -- Hyprland speed is a duration (deciseconds), so a slightly larger
        -- value makes the motion about 5-9% calmer without changing its curve.
        speed = 3.0,
        workspace_distance = "20%",
        settings = {
            windows = { speed = 3.2, style = "popin 94%" },
            windowsIn = { speed = 3.2, style = "popin 94%" },
            windowsOut = { speed = 2.6, style = "popin 94%" },
            windowsMove = { speed = 2.8 },
            layers = { speed = 3.0, style = "slide bottom" },
            layersIn = { speed = 3.0, style = "slide bottom" },
            layersOut = { speed = 2.5, style = "slide bottom" },
            border = { speed = 2.1 },
            zoomFactor = { speed = 3.0 },
            monitorAdded = { speed = 3.4 },
        },
    },

    lumen = {
        curve = "sakura_lumen",
        kind = "bezier",
        -- A little more time plus a softer curve makes Lumen feel graceful,
        -- not abrupt. Workspace travel distance remains unchanged.
        speed = 3.8,
        workspace_distance = "16%",
        settings = {
            windows = { speed = 4.1, style = "popin 98%" },
            windowsIn = { speed = 4.1, style = "popin 98%" },
            windowsOut = { speed = 3.4, style = "popin 98%" },
            windowsMove = { speed = 3.5 },
            layers = { speed = 3.9, style = "fade" },
            layersIn = { speed = 3.9, style = "fade" },
            layersOut = { speed = 3.1, style = "fade" },
            border = { speed = 3.0 },
            zoomFactor = { speed = 3.5 },
            monitorAdded = { speed = 4.0 },
        },
    },

    arctic = {
        curve = "sakura_arctic",
        kind = "spring",
        speed = 4.0,
        workspace_distance = "10%",
        settings = {
            windows = { speed = 4.1, style = "popin 97%" },
            windowsIn = { speed = 4.1, style = "popin 97%" },
            windowsOut = { speed = 3.3, style = "popin 97%" },
            windowsMove = { speed = 3.7 },
            layers = { speed = 4.0, style = "slide bottom" },
            layersIn = { speed = 4.0, style = "slide bottom" },
            layersOut = { speed = 3.2, style = "slide bottom" },
            border = { speed = 2.8 },
            zoomFactor = { speed = 3.4 },
            monitorAdded = { speed = 3.8 },
        },
    },

    jiggle = {
        curve = "sakura_jiggle",
        kind = "spring",
        speed = 3.4,
        workspace_distance = "22%",
        settings = {
            windows = { speed = 3.6, style = "popin 90%" },
            windowsIn = { speed = 3.6, style = "popin 90%" },
            windowsOut = { speed = 2.9, style = "popin 90%" },
            windowsMove = { speed = 3.1 },
            layers = { speed = 3.5, style = "slide top" },
            layersIn = { speed = 3.5, style = "slide top" },
            layersOut = { speed = 2.8, style = "slide top" },
            border = { speed = 2.7 },
            zoomFactor = { speed = 3.4 },
            monitorAdded = { speed = 3.6 },
        },
    },
}

local function apply_leaf(leaf, profile, override)
    local settings = override or {}

    -- Disabled profiles must not pass speed=0: Hyprland rejects
    -- non-positive speeds. Only leaf and enabled=false are required.
    if profile.disabled then
        hl.animation({
            leaf = leaf,
            enabled = false,
        })
        return
    end

    local args = {
        leaf = leaf,
        enabled = true,
        speed = settings.speed or profile.speed,
    }

    -- Workspace motion can use a dedicated curve without changing the
    -- profile's window/layer motion. Silk uses this to avoid a spring tail
    -- during workspace changes while keeping its original duration.
    if workspace_leaves[leaf] and profile.workspace_curve then
        args.bezier = profile.workspace_curve
    else
        args[profile.kind] = profile.curve
    end

    -- Always derive workspace direction here, not while building the profile
    -- table. Every profile follows the same horizontal/vertical selection.
    if workspace_leaves[leaf] then
        args.style = workspace_style(profile.workspace_distance or "12%")
    elseif settings.style then
        args.style = settings.style
    end

    hl.animation(args)
end

function M.set_workspace_direction(direction)
    if type(direction) ~= "string" then
        return false, "Workspace direction must be a string"
    end

    direction = string.lower(direction)
    if not is_valid_direction(direction) then
        return false, 'Workspace direction must be "horizontal" or "vertical"'
    end

    WORKSPACE_DIRECTION = direction
    return true
end

function M.get_workspace_direction()
    return WORKSPACE_DIRECTION
end

function M.apply(name, direction)
    if type(name) ~= "string" then
        return false, "Animation profile name must be a string"
    end

    if direction ~= nil then
        local direction_ok, direction_err = M.set_workspace_direction(direction)
        if not direction_ok then
            return false, direction_err
        end
    end

    name = string.lower(name)

    local profile = profiles[name]
    if not profile then
        return false, "Unknown animation profile: " .. name
    end

    -- Apply a root default, then explicitly set every leaf. This prevents
    -- styles and speeds from a previously active profile from leaking over.
    local ok, err = pcall(function()
        apply_leaf("global", profile)

        for _, leaf in ipairs(leaves) do
            if leaf ~= "global" then
                local is_angle_leaf =
                    leaf == "borderangle" or leaf == "shadowangle" or leaf == "glowangle"

                -- Keep angle animations disabled in visual profiles. In
                -- particular, never use the continuous "loop" style here:
                -- it forces constant redraws and can waste GPU/battery.
                if is_angle_leaf and name ~= "performance" then
                    hl.animation({ leaf = leaf, enabled = false })
                else
                    apply_leaf(leaf, profile, profile.settings[leaf])
                end
            end
        end
    end)

    if not ok then
        return false, tostring(err)
    end

    return true
end

return M
