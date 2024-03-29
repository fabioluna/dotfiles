# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without testriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, DropDown, Group, Key, KeyChord, Match, Screen, ScratchPad
from libqtile.lazy import lazy

mod = "mod4"

terminal = "kitty"


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move screen focus"),
    Key([mod, "mod1"], "h", lazy.next_screen(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod, "mod1"], "l", lazy.prev_screen(), desc="Move screen focus"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # My keybindings
    # Launch rofi
    Key(
        ["mod1"],
        "space",
        lazy.spawn("rofi -combi-modi window,drun -show combi -modi combi -show-icons"),
    ),
    Key([mod], "e", lazy.spawn("rofimoji")),
    # Edge Browser
    Key(
        [mod], "w", lazy.spawn("microsoft-edge-stable --force-device-scale-factor=1.5")
    ),
    Key([mod, "shift"], "w", lazy.spawn("microsoft-edge-stable --inprivate")),
    # Diodon
    Key([mod], "v", lazy.spawn("diodon")),
    # Quit qtile
    Key([mod], "Print", lazy.shutdown()),
    # Reboot
    Key([mod], "Scroll_Lock", lazy.spawn("qtile cmd-obj -o cmd -f reboot")),
    # Shutdown
    Key([mod], "Pause", lazy.spawn("qtile cmd-obj -o cmd -f shutdown -h now")),
    # Toggle sound source
    Key(
        [mod],
        "F12",
        lazy.spawn("python /home/fabio/.config/qtile/scripts/toggle_sound.py"),
    ),
    # Connect to bluetooth device
    Key(
        [mod],
        "F4",
        lazy.spawn("/home/fabio/.config/qtile/scripts/bluetooth_connect.sh"),
    ),
    # Media keys
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse set Master 1+ toggle")),
    # Change keyboard layout
    Key(
        [mod],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout.",
    ),
    # Pulse audio controls
    Key(
        [mod],
        "p",
        lazy.spawn("pavucontrol"),
    ),
    Key(
        ["mod1"],
        "F12",
        lazy.spawn("/home/thebalance/.config/qtile/scripts/dpi.sh"),
    ),
    Key(
        [mod],
        "a",
        lazy.spawn("arandr"),
    ),
    Key(
        [mod],
        "t",
        lazy.spawn("thunar"),
   ),
    KeyChord([mod], "s", [
        Key(
            [],
            "e",
            lazy.group["scratchpad"].dropdown_toggle("smile"),
        ),
        Key(
            [],
            "t",
            lazy.group["scratchpad"].dropdown_toggle("term"),
        ),
    ]),
]

groups = [Group(i) for i in "1234567890"]

scratchpad = ScratchPad("scratchpad", [
    DropDown("term", "kitty", opacity=0.8),
    DropDown("smile", "smile", opacity=0.8),
])

groups.append(scratchpad)

for i in groups:
    if i.name == "scratchpad":
        continue

    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Firacode Nerd Font",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename="~/Pictures/Icons/Galo.png",
                    scale="False",
                ),
                widget.CurrentLayoutIcon(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(
                    max_chars=50,
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Wttr(
                    location={"Florianopolis": "Floripa"},
                    format="%l:%c%t %p %w %m",
                    update_interval=36000,
                ),
                widget.Sep(),
                widget.Mpris2(
                    format="{xesam_title} - {xesam_artist}",
                    scroll=True,
                    scrol_fixed_width=True,
                ),
                widget.Volume(),
                widget.Volume(
                    emoji=True,
                ),
                widget.Sep(),
                widget.KeyboardLayout(configured_keyboards=["us", "br"]),
                widget.Sep(),
                widget.DF(visible_on_warn=False, format="💾 {f}{m}"),
                widget.Sep(),
                widget.Memory(
                    format="🧠 {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
                    measure_mem="G",
                ),
                widget.Sep(),
                widget.CPU(
                    format="󰻠 {freq_current}GHz {load_percent}%",
                ),
                widget.ThermalSensor(),
                widget.Sep(),
                widget.Wlan(
                    interface="wlan0",
                    format="{essid} {percent:2.0%}",
                ),
                widget.Sep(),
                widget.BatteryIcon(),
                widget.Battery(format="{percent:2.0%}"),
                widget.Sep(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p", timezone="America/Denver"),
            ],
            32,
            background="#1e1e2e",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename="~/Pictures/Icons/Galo.png",
                    scale="False",
                ),
                widget.CurrentLayoutIcon(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(
                    max_chars=50,
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Wttr(
                    location={"Florianopolis": "Floripa"},
                    format="%l:%c%t %p %w %m",
                    update_interval=36000,
                ),
                widget.Sep(),
                widget.Mpris2(
                    format="{xesam_title} - {xesam_artist}",
                    scroll=True,
                    scrol_fixed_width=True,
                ),
                widget.Volume(),
                widget.Volume(
                    emoji=True,
                ),
                widget.Sep(),
                widget.KeyboardLayout(configured_keyboards=["us", "br"]),
                widget.Sep(),
                widget.DF(visible_on_warn=False, format="💾 {f}{m}"),
                widget.Sep(),
                widget.Memory(
                    format="🧠 {MemUsed: .0f}{mm}/{MemTotal: .0f}{mm}",
                    measure_mem="G",
                ),
                widget.Sep(),
                widget.CPU(
                    format="󰻠 {freq_current}GHz {load_percent}%",
                ),
                widget.ThermalSensor(),
                widget.Sep(),
                widget.Wlan(
                    interface="wlan0",
                    format="{essid} {percent:2.0%}",
                ),
                widget.Sep(),
                widget.BatteryIcon(),
                widget.Battery(format="{percent:2.0%}"),
                widget.Sep(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            ],
            22,
            background="#1e1e2e",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# Autostart


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])
