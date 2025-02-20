{ config, pkgs, username, ... }:
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
    killall
    # binwalk
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
          background=config.scheme.base05;
          foreground=config.scheme.base00;

          ## Normal/regular colors (color palette 0-7)
          regular0=config.scheme.base01;  # black
          regular1=config.scheme.base08;  # red
          regular2=config.scheme.base0B;  # green
          regular3=config.scheme.base0A;  # yellow
          regular4=config.scheme.base0D;  # blue
          regular5=config.scheme.base0E;  # magenta
          regular6=config.scheme.base0C;  # cyan
          regular7=config.scheme.base06;  # white

          ## Bright colors (color palette 8-15)
          bright0=config.scheme.base02;  # bright black
          bright1=config.scheme.base08;  # bright red
          bright2=config.scheme.base0B;  # bright green
          bright3=config.scheme.base0A;  # bright yellow
          bright4=config.scheme.base0D;  # bright blue
          bright5=config.scheme.base0E;  # bright magenta
          bright6=config.scheme.base0C;  # bright cyan
          bright7=config.scheme.base07;  # bright white


          ## Misc colors
          "16"=config.scheme.base09;
          "17"=config.scheme.base0F;
          "18"=config.scheme.base01;
          "19"=config.scheme.base02;
          "20"=config.scheme.base04;
          "21"=config.scheme.base06;
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
            tide configure --auto --style=Classic --prompt_colors='16 colors' --show_time='24-hour format' --classic_prompt_separators=Vertical --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_spacing=Compact --icons='Many icons' --transient=Yes
      '';

      shellAbbrs  = {
        "vim"               = "nvim";
        "svim"              = "sudo -E nvim";
        "batt"              = "upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty";
        "ip"                = "ip -color = auto";
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

        "nix-ls-installed"  = "nix-store -q --references /var/run/current-system/sw | cut -d'-' -f2-" ;
        "deletepw"          = "cliphist list | head -n1 | cliphist delete";
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
