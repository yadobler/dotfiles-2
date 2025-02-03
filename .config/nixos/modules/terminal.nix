{ lib, pkgs, username, ... }:
let
  shell = "/var/run/current-system/sw/bin/fish";
  terminal = "/run/current-system/sw/bin/foot";
  # alias "bw_unlock"="[[ \$(bw status | jq '.status') == 'unlocked' ]] || export BW_SESSION=\$(bw unlock \$(zenity --password) --raw)"
in
  {
  documentation.man.generateCaches = true;
  environment.systemPackages = with pkgs; [
    fishPlugins.tide
    fishPlugins.puffer
    fishPlugins.sponge
    fishPlugins.fzf
    any-nix-shell

    file
    lsd
    fd
    dust
    duf
    fzf
    ripgrep
    bottom
    neofetch
    pstree
    tree
    unzip
    p7zip
    wget
    jq
    bc
    binwalk
  ];
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=12";
        };

        url = {
          launch = "open ${"url"}";
        };

        colors = {
          # alpha=1 | 0
          background="16181A";
          foreground="FFFFFF";

          ## Normal/regular colors (color palette 0-7)
          regular0="16181A";  # black
          regular1="FF6E5E";  # red
          regular2="5EFF6C";  # green
          regular3="F1FF5E";  # yellow
          regular4="5EA1FF";  # blue
          regular5="BD5EFF";  # magenta
          regular6="5EF1FF";  # cyan
          regular7="FFFFFF";  # white

          ## Bright colors (color palette 8-15)
          bright0="3C4048";  # bright black
          bright1="FF6E5E";  # bright red
          bright2="5EFF6C";  # bright green
          bright3="F1FF5E";  # bright yellow
          bright4="5EA1FF";  # bright blue
          bright5="BD5EFF";  # bright magenta
          bright6="5EF1FF";  # bright cyan
          bright7="FFFFFF";  # bright white


          ## Misc colors
          selection-foreground="16181A";
          selection-background="FFFFFF";
          urls="00a8ba";  
        };
      };
    };
    
    direnv.enable = true;

    fish = {
      enable = true;

      loginShellInit = ''
            if test (tty) = /dev/tty1
              exec Hyprland
            end
      '';

      interactiveShellInit = ''
            any-nix-shell fish --info-right | source
            direnv hook fish | source
            fish_vi_key_bindings
            tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time='24-hour format' --rainbow_prompt_separators=Slanted --powerline_prompt_heads=Slanted --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
      '';

      shellAbbrs  = {
        "vim"               = "nvim";
        "svim"              = "sudo -E nvim";
        "batt"              = "upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty";
        "ip"                = "ip -color   = auto";
        "ls"                = "lsd --group-directories-first -N";
        "la"                = "lsd --group-directories-first -lA";
        "ll"                = "lsd --group-directories-first -lAhN";
        "cat"               = "bat";
        "du"                = "dust -r";
        "df"                = "duf";
        "ps"                = "procs";
        "htop"              = "btm";
        "grep"              = "rg";
        "find"              = "fd";
        "imgcat"            = "img2sixel";

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

  system.userActivationScripts.postInstallTerminal = ''
      rm -rf /usr/bin/gnome-terminal
      ln -s ${terminal} /usr/bin/gnome-terminal
      '';
}
