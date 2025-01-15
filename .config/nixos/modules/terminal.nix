{ lib, pkgs, username, ... }:
let
  terminal = "/run/current-system/sw/bin/foot";
  shell = "/var/run/current-system/sw/bin/fish";
  # alias "bw_unlock"="[[ \$(bw status | jq '.status') == 'unlocked' ]] || export BW_SESSION=\$(bw unlock \$(zenity --password) --raw)"
in
  {
  config = {
    programs = {
      foot = {
        enable = true;
      }
        fish = {
          enable = true;
          loginShellInit = ''
            if test (tty) = /dev/tty1
              exec Hyprland
            end
          '';
          shellInit = ''

          '';
          interactiveShellInit = ''
            fish_vi_key_bindings
          '';

          shellAbbrs  = {
            "vim"               = "nvim";
            "svim"              = "sudo -E nvim";
            "batt"              = "upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty";
            "ip"                = "ip -color   = auto";
            "ls"                = "lsd --group-directories-first";
            "la"                = "lsd --group-directories-first -lA";
            "ll"                = "lsd --group-directories-first -lAhN";
            "cat"               = "bat";
            "du"                = "dust";
            "ps"                = "procs";
            "htop"              = "btm";
            "grep"              = "rg";
            "find"              = "fd";
            "jobs"              = "jobs -p";

            "wal_update"        = "~/.config/scripts/wallust_update.sh";
            "steam_update_apps" = "sed 's/Exec = steam /Exec = gamemoderun steam /g' -i ~/.local/share/applicationsCC/*";
            "valgrind"          = "~/.config/scripts/colorgrind";
            "footserver"        = "foot --server &; disown";
            "cd.."              = "cd ..";
            ":q"                = "exit";

            "ga"                = "git add";
            "gaf"               = "git add -f";
            "gau"               = "git add -u";
            "gcm"               = "git commit -m";
            "gc"                = "git commit";
            "gm"                = "git merge";
            "gmnoff"            = "git merge --no-ff";
            "gp"                = "git push";
            "gpo"               = "git push -u origin $(git branch --show-current)";
            "gptags"            = "git push --tags";
            "gpull"             = "git pull";
            "gs"                = "git status";
            "gd"                = "git diff";
            "gdc"               = "git diff --cached";
            "gl"                = "git log";
            "glg"               = "git log --color --graph --pretty --oneline";
            "glgb"              = "git log --all --graph --decorate --oneline --simplify-by-decoration";

            "gswitch"           = "git switch";
            "gswitchc"          = "git switch -c";
            "gsm"               = "git submodule";

            "gtag"              = "git tag";
            "gco"               = "git checkout";
            "gcob"              = "git checkout -b";
            "gcom"              = "git checkout master";
            "gcod"              = "git checkout develop";
          };
        };
    };

    users.users.${username}.shell = shell;
    users.defaultUserShell = shell;

    system.activationScripts.postInstall = ''
      rm -rf /usr/bin/gnome-terminal
      ln -s ${terminal} /usr/bin/gnome-terminal
      '';
  };
}
