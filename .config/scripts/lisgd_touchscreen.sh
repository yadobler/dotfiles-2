#!/usr/bin/env /bin/sh

lisgd \
    -d /dev/input/by-path/pci-0000:00:15.1-platform-i2c_designware.3-event \
    -g "4,LR,*,S,P,hyprctl dispatch workspace r-1" \
    -g "4,RL,*,S,P,hyprctl dispatch workspace r+1"
