#!/bin/zsh
source $HOME/.cache/wal/colors.sh
rm -f ~/Pictures/Wallpaper/cropped-image.jpg

HEIGHT=$(identify -ping -format "%h" "$wallpaper")
WIDTH=$(identify -ping -format "%w" "$wallpaper")

# Which portion to start (0.0 top - 1.0 bottom)
PORTION_RATIO=0.75

# Screen ratio - 3000/2000
SCREEN_RATIO="3/2"

# using python to round off numbers, so might as well use it for all
DIMENSION=$(python -c "
(w,h,x,y,ratio)=($WIDTH,$HEIGHT,0,0,$SCREEN_RATIO);
(w,h,x,y)=(w,w/ratio,0,$PORTION_RATIO*(h-w/ratio)) if w/h<ratio else (h*ratio,h,$PORTION_RATIO*(w-h*ratio),0)
print(f'{int(w)}x{int(h)}+{int(x)}+{int(y)}')")

convert $wallpaper -crop $DIMENSION ~/Pictures/Wallpaper/cropped-image.jpg
#swww img -f Nearest -t none ~/Pictures/Wallpaper/cropped-image.jpg
walogram

killall waybar
waybar &
disown

killall wbg
wbg ~/Pictures/Wallpaper/cropped-image.jpg &
disown

