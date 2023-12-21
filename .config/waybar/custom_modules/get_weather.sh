#!/usr/bin/env bash
for i in {1..5}
do
    text=$(curl -s "https://wttr.in/$1?format=%m+%t+(%f)+%C+%c")
    if [[ $? == 0 ]]
    then
        text=$(echo "$text" | sed -E "s/\s+/ /g")
        tooltip=$(curl -s "https://wttr.in/$1?format=%l:+%c%C+\\r%t+(feels%20like:+%f)+\\r%w")
        if [[ $? == 0 ]]
        then
            tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
            echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
            exit
        fi
    fi
    sleep 2
done
echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
