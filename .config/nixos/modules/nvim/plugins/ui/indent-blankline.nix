{
  plugins = {
    indent-blankline = {
      enable = true;
      settings = {
        indent = {
          char = "│"; # "│" or "▎"
          tab_char = "│";
          highlight = [
            "RainbowRed"
            "RainbowYellow"
            "RainbowBlue"
            "RainbowOrange"
            "RainbowGreen"
            "RainbowViolet"
            "RainbowCyan"
          ];
        };
        scope.enabled = false;
        exclude = {
          buftypes = [
            "terminal"
            "nofile"
          ];
          filetypes = [
            "help"
            "alpha"
            "dashboard"
            "neo-tree"
            "Trouble"
            "trouble"
            "lazy"
            "mason"
            "notify"
            "toggleterm"
            "lazyterm"
          ];
        };
      };
    };
  };
}
