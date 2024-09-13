{ lib, pkgs, ... }:
let
  terminal = pkgs.foot;
  binary_name = "foot";
  shell = pkgs.zsh;
in
{
  options.terminal.postInstallScript = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Post-install set gnome-terminal to ${binary_name} for gnome-based apps";
  };

  config = {
    programs = {
      zsh = {
        enable = true;
        syntaxHighlighting = {
          enable = true;
        };
        autosuggestions = {
          enable = true;
        };
        enableLsColors = true;
        enableCompletion = true;
        enableBashCompletion = true;
        setOptions = [
          "auto_list"
          "complete_in_word"
          "menu_complete"
          "extended_glob"
          "glob"
          "append_history"
          "share_history"
          "nobeep"
          "longlistjobs"
          "notify"
        ];
        shellAliases = {
          vim = "nvim";
            "svim" = "sudo -E nvim";
            "batt" = "upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -e state -e percentage -e time\ to\ empty";
            "ip" = "ip -color=auto";
            "ls" = "lsd --group-directories-first";
            "la" = "ls -lA";
            "ll" = "la -hN";
            "cat" = "bat";
            "du" = "dust";
            "ps" = "procs";
            "htop" = "btm";
            "grep" = "rg";
            "find" = "fd";
            "jobs" = "jobs -p";

            "wal_update" = "~/.config/scripts/wallust_update.sh";
            "steam_update_apps" = "sed 's/Exec=steam /Exec=gamemoderun steam /g' -i ~/.local/share/applicationsCC/*";
            "valgrind" = "~/.config/scripts/colorgrind";
            "footserver" = "foot --server &; disown";
            "cd.." = "cd ..";
            ":q" = "exit";

            "gaf" = "git add -f";
            "gau" = "git add -u";
            "gcm" = "git commit -m";
            "gc" = "git commit -m";
            "gm" = "git merge";
            "gm-noff" = "git merge --no-ff";
            "gp" = "git push";
            "gpo" = "git push -u origin";
            "gptags" = "git push --tags";
            "gpull" = "git pull";
            "gs" = "git status";
            "gl" = "git log";
            "gswitch" = "git switch";
            "gswitchc" = "git switch -c";
            "gsm" = "git submodule";
            "gtag" = "git tag";
        };
      };
    };
    
    users.users.yukna.shell = shell;
    environment.systemPackages = [
      terminal

    ];

    terminal.postInstallScript = ''
      rm -rf /usr/bin/gnome-terminal
      ln -s ${terminal}/bin/${binary_name} /usr/bin/gnome-terminal
      '';


  };
}
