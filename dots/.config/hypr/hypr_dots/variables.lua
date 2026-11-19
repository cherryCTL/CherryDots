local M = {}


M.mainMod = "SUPER"
M.secendMod = "ALT"
auto_lan = "hyprctl switchxkblayout at-translated-set-2-keyboard 0 0 && "

M.terminal = auto_lan .. "kitty"
M.terminal2 = auto_lan .. "alacritty"
M.fileManager = auto_lan .. "thunar"
M.fileManager2 = auto_lan ..'nautilus -w'
M.KillFilemanager2 = "killall -9 nautilus && notify-send nautilus 'nautilus stoped'"
M.menu_luncher = auto_lan .. "noctalia msg panel-open launcher"
M.browser = auto_lan .. "brave-origin"
M.browser_private = auto_lan .. "brave-origin --incognito"
M.browser2 = auto_lan .. "zen-browser"
M.browser2_private = auto_lan .. "zen-browser --private-window"
M.editor = "vscodium"
M.gameEngine = "godot"
M.SystemMonitor = "missioncenter"
M.screenshot1 = "noctalia msg screenshot-annotate"
M.screenshot2 = "noctalia msg screenshot-fullscreen"
M.emoji_picker = auto_lan .. "noctalia msg panel-open launcher /emo"
M.emoji_picker2 = auto_lan .. "noctalia msg panel-open launcher /kao"
M.lock_screen = auto_lan .. "noctalia msg session lock"
M.power = auto_lan .. "noctalia msg panel-open session"
M.setting = auto_lan .. "noctalia msg settings-open"
M.power_profile = "noctalia msg power-cycle"
M.wallpaper_menu = auto_lan .. "noctalia msg panel-toggle wallpaper"
M.wallpaper_next = "noctalia msg wallpaper-previous"
M.wallpaper_prev = "noctalia msg wallpaper-next"
M.wallpaper_rand = "noctalia msg wallpaper-random"
M.colorpicker = auto_lan .. "hyprpicker -a -f hex"


M.SystemUpdate = auto_lan .. [[kitty --title "System Update" bash -c '
run_step() {
    label="$1"
    shift
    "$@"
    status=$?

    if [ "$status" -ne 0 ]; then
        notify-send -u critical "System Update" "خطا در مرحله: $label (کد $status)"
        exit "$status"
    fi
}

if ! sudo -v; then
    notify-send -u critical "System Update" "احراز هویت ناموفق بود"
    exit 1
fi

run_step "pacman" sudo pacman -Syu
run_step "yay" yay -Syu
run_step "flatpak" flatpak update -y
run_step "hyprpm" hyprpm update

echo
echo "همه آپدیت‌ها با موفقیت تموم شد!"
notify-send "System Update" "تمام آپدیت‌ها با موفقیت انجام شدند."
sleep 2
' ]]




return M