any-nix-shell fish --info-right | source
direnv hook fish | source
fish_vi_key_bindings
tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Many icons' --transient=Yes
set -gx EDITOR nvim
set -gx BAT_PAGER "/run/current-system/sw/bin/less -RFI"
