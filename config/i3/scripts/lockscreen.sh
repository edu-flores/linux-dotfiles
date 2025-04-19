#!/bin/bash

# Colors
TRANSPARENT="#00000000"
WHITE="#ffffff"
BLACK="#000000"
URGENT="#ff7043"

# Fonts
UI_FONT="Inter SemiBold"
NERD_FONT="JetBrainsMono NFP SemiBold"

# Wallpaper
current_wallpaper=$(awk '{print $4}' ~/.fehbg | tr -d "'")
blurred_wallpaper="/tmp/blurred_wallpaper.png"
ffmpeg -i $current_wallpaper -vf "gblur=sigma=5" $blurred_wallpaper -y > /dev/null 2>&1

# Pause notifications
pause_level=$(dunstctl get-pause-level)
dunstctl set-paused true

# Start lockscreen
i3lock                              \
--nofork                            \
--fill                              \
--clock                             \
--radius 15                         \
--ring-width 5                      \
\
--inside-color $TRANSPARENT         \
--ring-color $WHITE                 \
--insidever-color $WHITE            \
--ringver-color $WHITE              \
--insidewrong-color $URGENT         \
--ringwrong-color $WHITE            \
--line-color $TRANSPARENT           \
--keyhl-color $BLACK                \
--bshl-color $URGENT                \
--separator-color $WHITE            \
--verif-color $TRANSPARENT          \
--wrong-color $TRANSPARENT          \
--modif-color $TRANSPARENT          \
--layout-color $TRANSPARENT         \
--time-color $WHITE                 \
--date-color $WHITE                 \
--greeter-color $WHITE              \
\
--time-str "%I:%M %p"               \
--date-str "%A %d %B"               \
--verif-text ""                     \
--wrong-text ""                     \
--noinput-text ""                   \
--lock-text ""                      \
--lockfailed-text ""                \
--greeter-text ""                  \
--no-modkey-text                    \
\
--time-font "$UI_FONT"              \
--date-font "$UI_FONT"              \
--greeter-font "$NERD_FONT"         \
\
--verif-size "18"                   \
--time-size "64"                    \
--date-size "40"                    \
--greeter-size "24"                 \
\
--ind-pos x+w-60:y+60               \
--time-pos x/2+w/2:y/2+h/2          \
--date-pos x/2+w/2:y/2+h/2+60       \
--greeter-pos ix-50:iy+8            \
\
--image "$blurred_wallpaper"

# Restore notifications
dunstctl set-pause-level $pause_level
