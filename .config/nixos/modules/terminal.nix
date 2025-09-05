{ colorScheme, pkgs, username, ... }:
let
  shell = "/var/run/current-system/sw/bin/fish";
  terminal = "foot";
  # alias "bw_unlock"="[[ \$(bw status | jq '.status') == 'unlocked' ]] || export BW_SESSION=\$(bw unlock \$(zenity --password) --raw)"
in
  {
  documentation.man.generateCaches = true;
  
  programs.foot = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font Mono:size=12";
        pad = "10x10";
        notify="notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
      };

      url.launch = "xdg-open \${url}";
      colors = {
        "foreground" = colorScheme.palette.base05;
        "background" = colorScheme.palette.base00;
        "regular0" = colorScheme.palette.base00; # black
        "regular1" = colorScheme.palette.base08; # red
        "regular2" = colorScheme.palette.base0B; # green
        "regular3" = colorScheme.palette.base0A; # yellow
        "regular4" = colorScheme.palette.base0D; # blue
        "regular5" = colorScheme.palette.base0E; # magenta
        "regular6" = colorScheme.palette.base0C; # cyan
        "regular7" = colorScheme.palette.base05; # white
        "bright0" = colorScheme.palette.base02; # bright black
        "bright1" = colorScheme.palette.base08; # bright red
        "bright2" = colorScheme.palette.base0B; # bright green
        "bright3" = colorScheme.palette.base0A; # bright yellow
        "bright4" = colorScheme.palette.base0D; # bright blue
        "bright5" = colorScheme.palette.base0E; # bright magenta
        "bright6" = colorScheme.palette.base0C; # bright cyan
        "bright7" = colorScheme.palette.base07; # bright white
        "16" = colorScheme.palette.base09;
        "17" = colorScheme.palette.base0F;
        "18" = colorScheme.palette.base01;
        "19" = colorScheme.palette.base02;
        "20" = colorScheme.palette.base04;
        "21" = colorScheme.palette.base06;
      };
    };
  };

  # environment.variables = {
  # };

  environment.systemPackages = [
    # pkgs.${terminal}
  ] ++ (with pkgs; [
    fishPlugins.puffer
    fishPlugins.sponge
    fishPlugins.bass 
    fishPlugins.fzf-fish
    fishPlugins.tide

    ghostty

    any-nix-shell

    file
    lsd
    fd
    dust
    duf
    fzf
    hexyl
    ripgrep
    bottom
    neofetch
    broot
    tree
    pstree
    chafa
    unzip
    p7zip
    wget
    jq
    bc
    killall
    # binwalk
    yazi
  ]);

  programs = {
    direnv.enable = true;
    nautilus-open-any-terminal.terminal = terminal;

    fish = {
      enable = true;
      loginShellInit = ''
            if test (tty) = /dev/tty1
              exec niri-session
            end
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
        "hexdump"           = "hexyl";
        "du"                = "dust -r";
        "df"                = "duf";
        "ps"                = "procs";
        "htop"              = "btm";
        "grep"              = "rg";
        "find"              = "fd";
        "imgcat"            = "img2sixel";
        
        "rebuild-os"        = "sudo nixos-rebuild switch --keep-going";
        # "wal_update"        = "~/.config/scripts/wallust_update.sh";
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

    # system.userActivationScripts.postInstallTerminal = ''
    #     rm -rf /usr/bin/gnome-terminal
    #     ln -s /run/current-system/sw/bin/${terminal} /usr/bin/gnome-terminal
    # '';
}
