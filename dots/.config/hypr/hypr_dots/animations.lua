-- ============================================================
-- SAKURA ANIMATION PROFILES
-- Hyprland 0.57+ Lua API
-- Profiles are applied by shortcuts_system.lua.
-- ============================================================

local M = {}

-- ============================================================
-- GLOBAL WORKSPACE CONTROL
-- ============================================================
local WORKSPACE_DIRECTION = "vertical" -- "horizontal" or "vertical"

assert(
    WORKSPACE_DIRECTION == "horizontal" or WORKSPACE_DIRECTION == "vertical",
    'WORKSPACE_DIRECTION must be "horizontal" or "vertical"'
)

-- Each appearance profile keeps its own animation speeds and spring values.
local function register_spring(name, stiffness, damping)
    hl.curve(name, {
        type = "spring",
        mass = 1.0,
        stiffness = stiffness,
        damping = damping,
    })
end

local function workspace_style(amount)
    local style = WORKSPACE_DIRECTION == "vertical" and "slidefadevert" or "slidefade"
    return style .. " " .. amount
end

-- Custom curves are registered once when this module is required.
hl.curve("sakura_normal", {
    type = "bezier",
    points = { {0.22, 1.0}, {0.36, 1.0} },
})

-- Mac-like, controlled spring with a soft settle.
register_spring("sakura_glass", 190, 24)

-- Fast, controlled bezier motion; no spring bounce or wobble.
hl.curve("sakura_gamer", {
    type = "bezier",
    points = { {0.16, 1.0}, {0.30, 1.0} },
})

-- Windows Aero: smooth ease-out, without spring bounce.
hl.curve("sakura_aero", {
    type = "bezier",
    points = { {0.16, 1.0}, {0.30, 1.0} },
})

-- Frost: quiet, icy and slightly overdamped, so it settles without wobble.
-- About 15% slower than the average tempo of the other spring-based profiles.
register_spring("sakura_frost", 176.5, 29.2)

-- Jelly: a soft, expressive spring curve paired with native window wobble.
register_spring("sakura_jelly", 230, 16)

-- These are the actual animation leaves in the Hyprland animation tree.
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
local profiles = {
    -- Performance disables every leaf through the API's enabled flag.
    -- A speed of 0 is invalid. Workspace direction has no visible effect
    -- while transitions are disabled; the shared variable is used by all
    -- profiles that actually animate workspaces.
    performance = {
        disabled = true,
        settings = {},
    },

    normal = {
        curve = "sakura_normal",
        kind = "bezier",
        speed = 3.0,
        settings = {
            windows = { speed = 4.0, style = "popin 96%" },
            windowsIn = { speed = 3.5, style = "popin 96%" },
            windowsOut = { speed = 2.8, style = "popin 96%" },
            windowsMove = { speed = 3.0 },
            layers = { speed = 3.5, style = "fade" },
            layersIn = { speed = 3.5, style = "fade" },
            layersOut = { speed = 2.8, style = "fade" },
            workspaces = { speed = 4.0, style = workspace_style("12%") },
            workspacesIn = { speed = 4.0, style = workspace_style("12%") },
            workspacesOut = { speed = 4.0, style = workspace_style("12%") },
            specialWorkspace = { speed = 4.0, style = workspace_style("12%") },
            specialWorkspaceIn = { speed = 4.0, style = workspace_style("12%") },
            specialWorkspaceOut = { speed = 4.0, style = workspace_style("12%") },
            border = { speed = 2.5 },
            zoomFactor = { speed = 3.0 },
            monitorAdded = { speed = 4.0 },
        },
    },

    glass = {
        curve = "sakura_glass",
        kind = "spring",
        speed = 4.0,
        settings = {
            windows = { speed = 5.5, style = "popin 92%" },
            windowsIn = { speed = 5.5, style = "popin 92%" },
            windowsOut = { speed = 4.5, style = "popin 92%" },
            windowsMove = { speed = 4.5 },
            layers = { speed = 5.0, style = "fade" },
            layersIn = { speed = 5.0, style = "fade" },
            layersOut = { speed = 4.0, style = "fade" },
            workspaces = { speed = 5.0, style = workspace_style("14%") },
            workspacesIn = { speed = 5.0, style = workspace_style("14%") },
            workspacesOut = { speed = 5.0, style = workspace_style("14%") },
            specialWorkspace = { speed = 5.0, style = workspace_style("14%") },
            specialWorkspaceIn = { speed = 5.0, style = workspace_style("14%") },
            specialWorkspaceOut = { speed = 5.0, style = workspace_style("14%") },
            border = { speed = 3.5 },
            zoomFactor = { speed = 5.0 },
            monitorAdded = { speed = 5.0 },
        },
    },

    gamer = {
        curve = "sakura_gamer",
        kind = "bezier",
        speed = 2.8,
        settings = {
            windows = { speed = 3.2, style = "popin 94%" },
            windowsIn = { speed = 3.2, style = "popin 94%" },
            windowsOut = { speed = 2.5, style = "popin 94%" },
            windowsMove = { speed = 2.8 },
            layers = { speed = 3.0, style = "slide bottom" },
            layersIn = { speed = 3.0, style = "slide bottom" },
            layersOut = { speed = 2.5, style = "slide bottom" },
            workspaces = { speed = 3.5, style = workspace_style("24%") },
            workspacesIn = { speed = 3.5, style = workspace_style("24%") },
            workspacesOut = { speed = 3.5, style = workspace_style("24%") },
            specialWorkspace = { speed = 3.5, style = workspace_style("24%") },
            specialWorkspaceIn = { speed = 3.5, style = workspace_style("24%") },
            specialWorkspaceOut = { speed = 3.5, style = workspace_style("24%") },
            border = { speed = 2.2 },
            zoomFactor = { speed = 3.0 },
            monitorAdded = { speed = 3.5 },
        },
    },

    aero = {
        curve = "sakura_aero",
        kind = "bezier",
        speed = 3.5,
        settings = {
            windows = { speed = 4.5, style = "popin 98%" },
            windowsIn = { speed = 4.5, style = "popin 98%" },
            windowsOut = { speed = 3.5, style = "popin 98%" },
            windowsMove = { speed = 3.5 },
            layers = { speed = 4.0, style = "fade" },
            layersIn = { speed = 4.0, style = "fade" },
            layersOut = { speed = 3.0, style = "fade" },
            workspaces = { speed = 4.5, style = workspace_style("18%") },
            workspacesIn = { speed = 4.5, style = workspace_style("18%") },
            workspacesOut = { speed = 4.5, style = workspace_style("18%") },
            specialWorkspace = { speed = 4.5, style = workspace_style("18%") },
            specialWorkspaceIn = { speed = 4.5, style = workspace_style("18%") },
            specialWorkspaceOut = { speed = 4.5, style = workspace_style("18%") },
            border = { speed = 3.0 },
            zoomFactor = { speed = 3.5 },
            monitorAdded = { speed = 4.0 },
        },
    },

    frost = {
        curve = "sakura_frost",
        kind = "spring",
        speed = 3.5,
        settings = {
            windows = { speed = 4.2, style = "popin 97%" },
            windowsIn = { speed = 4.2, style = "popin 97%" },
            windowsOut = { speed = 3.5, style = "popin 97%" },
            windowsMove = { speed = 3.85 },
            layers = { speed = 3.85, style = "slide bottom" },
            layersIn = { speed = 3.85, style = "slide bottom" },
            layersOut = { speed = 3.15, style = "slide bottom" },
            workspaces = { speed = 4.2, style = workspace_style("10%") },
            workspacesIn = { speed = 4.2, style = workspace_style("10%") },
            workspacesOut = { speed = 4.2, style = workspace_style("10%") },
            specialWorkspace = { speed = 4.2, style = workspace_style("10%") },
            specialWorkspaceIn = { speed = 4.2, style = workspace_style("10%") },
            specialWorkspaceOut = { speed = 4.2, style = workspace_style("10%") },
            border = { speed = 3.15 },
            zoomFactor = { speed = 3.85 },
            monitorAdded = { speed = 4.2 },
        },
    },

    jelly = {
        curve = "sakura_jelly",
        kind = "spring",
        speed = 3.8,
        settings = {
            windows = { speed = 4.0, style = "popin 88%" },
            windowsIn = { speed = 4.0, style = "popin 88%" },
            windowsOut = { speed = 3.2, style = "popin 88%" },
            windowsMove = { speed = 3.5 },
            layers = { speed = 3.8, style = "slide top" },
            layersIn = { speed = 3.8, style = "slide top" },
            layersOut = { speed = 3.0, style = "slide top" },
            workspaces = { speed = 4.2, style = workspace_style("30%") },
            workspacesIn = { speed = 4.2, style = workspace_style("30%") },
            workspacesOut = { speed = 4.2, style = workspace_style("30%") },
            specialWorkspace = { speed = 4.2, style = workspace_style("30%") },
            specialWorkspaceIn = { speed = 4.2, style = workspace_style("30%") },
            specialWorkspaceOut = { speed = 4.2, style = workspace_style("30%") },
            border = { speed = 3.0 },
            zoomFactor = { speed = 4.0 },
            monitorAdded = { speed = 4.2 },
        },
    },
}

local function apply_leaf(leaf, profile, override)
    local settings = override or {}

    -- Disabled profiles must not pass speed=0: hl.animation() rejects
    -- non-positive speeds. The API returns immediately when enabled=false,
    -- so only the leaf and enabled flag are sent for Performance.
    if profile.disabled then
        hl.animation({
            leaf = leaf,
            enabled = false,
        })
        return
    end

    -- Every enabled leaf uses its own speed when provided; otherwise it uses
    -- the default speed defined by its appearance profile.
    local args = {
        leaf = leaf,
        enabled = true,
        speed = settings.speed or profile.speed,
    }

    args[profile.kind] = profile.curve

    if settings.style then
        args.style = settings.style
    end

    hl.animation(args)
end

function M.apply(name)
    if type(name) ~= "string" then
        return false, "Animation profile name must be a string"
    end

    name = string.lower(name)

    local profile = profiles[name]
    if not profile then
        return false, "Unknown animation profile: " .. name
    end

    -- Apply a root default, then explicitly set every leaf. This prevents
    -- styles/speeds from an earlier profile from leaking into the next one.
    local ok, err = pcall(function()
        apply_leaf("global", profile)

        for _, leaf in ipairs(leaves) do
            if leaf ~= "global" then
                local is_angle_leaf =
                    leaf == "borderangle" or leaf == "shadowangle" or leaf == "glowangle"

                -- Preserve the existing angle-animation policy in visual
                -- profiles. Performance is explicit: every leaf, including
                -- angle leaves, is enabled with a zero-duration transition.
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
