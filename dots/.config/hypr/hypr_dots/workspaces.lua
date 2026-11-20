local workspaces = {
    [1]  = "Browser",
    [2]  = "Work",
    [3]  = "Testing",
    [4]  = "Tasks",
    [5]  = "Social",
    [6]  = "Gaming",
    [7]  = "Video",
    [8]  = "Music",
    [9]  = "Capture",
    [10] = "Network",
}

for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        persistent = true,
        default_name = workspaces[i],
    })
end