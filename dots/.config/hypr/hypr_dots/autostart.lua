hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("snappy-switcher --daemon")
    hl.exec_cmd("sleep 2 && SakuraDesktopIcons")
end)

