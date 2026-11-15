
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1.0",
})

--for crt tv
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "800x600@60",
    position = "auto",
    scale    = "0.7",
})

hl.bind("SUPER + MINUS", hl.dsp.focus({
    monitor = "HDMI-A-1",
}))