#!/usr/bin/env /bin/sh
hyprctl clients -j \
    | jq -r ".[] | select(.workspace.id == $(hyprctl activeworkspace -j | jq -r ".id")) | .at,.size" \
    | jq -s "add | _nwise(4)" \
    | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"' \
    | slurp -r
