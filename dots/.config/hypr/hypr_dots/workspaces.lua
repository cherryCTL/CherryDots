local workspaces = {
    [1]  = "Web",
    [2]  = "Work",
    [3]  = "Lab",
    [4]  = "Tasks",
    [5]  = "Chat",
    [6]  = "Game",
    [7]  = "Video",
    [8]  = "Audio",
    [9]  = "Extra",
    [10] = "Route",
}

for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        persistent = true,
        default_name = workspaces[i],
    })
end