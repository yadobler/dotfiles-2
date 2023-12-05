#! /bin/sh
ls -1 /usr/lib/python3.11/site-packages/pywal/colorschemes/dark \
    | while IFS= read -r file
do
    echo $file: ;
    counter=0;
    cat /usr/lib/python3.11/site-packages/pywal/colorschemes/dark/$file \
        | jq -r ".colors[]" \
        | while IFS= read -r line; 
    do 
        r=$(printf '%d' "0x${line:1:2}")
        g=$(printf '%d' "0x${line:3:2}")
        b=$(printf '%d' "0x${line:5:2}")
        # printf '\e[0;48;2;%s;%s;%sm\e[38;2;%s;%s;%sm %#.2d ' "$r" "$g" "$b" "$((255 - r))" "$((255 - g))" "$((255 - b))"  "$counter"
        printf '\e[0;48;2;%s;%s;%sm  ' "$r" "$g" "$b"
        if [[ "$counter" -eq 7 ]]; then
            printf '\e[0m\n'; 
        fi
        counter=$((counter + 1));
    done; 
    printf '\e[0m\n'; 
done
