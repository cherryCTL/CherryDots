local workspaces = {
    [1]  = "Browser",
    [2]  = "Work",
    [3]  = "Testing",
    [4]  = "Productivity",
    [5]  = "Social",
    [6]  = "Capture",
    [7]  = "Gaming",
    [8]  = "Video",
    [9]  = "Music",
    [10] = "Network",
}

for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        persistent = true,
        default_name = workspaces[i],
    })
end