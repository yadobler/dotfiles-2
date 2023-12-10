#! /usr/bin/zsh
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword misc:animate_mouse_windowdragging 0;\
        keyword misc:animate_manual_resizes 0;\
        keyword animations:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:extend_border_grab_area 50;\
        keyword general:border_size 1;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:rounding 0"
    exit
else
    hyprctl --batch "\
        keyword misc:animate_mouse_windowdragging 1;\
        keyword misc:animate_manual_resizes 1;\
        keyword animations:enabled 1;\
        keyword general:gaps_in 5;\
        keyword general:gaps_out 10;\
        keyword general:border_size 2;\
        keyword general:extend_border_grab_area 15;\
        keyword decoration:blur:enabled 1;\
        keyword decoration:drop_shadow 1;\
        keyword decoration:rounding 10"
    exit
fi
hyprctl reload
