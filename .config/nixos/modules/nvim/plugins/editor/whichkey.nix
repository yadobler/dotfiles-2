{
  plugins.which-key = {
    enable = true;
    settings = {

      icons = {
        breadcrumb = "»";
        group = "+";
        separator = "➜"; # 
      };

      win = {
        border = "double";
        padding = [ 1 1 ];
      };

      spec = [
        { group = "+code";          __unkeyed-1 = "<leader>c"; mode = [ "n" "v" ]; }
        { group = "+debug";         __unkeyed-1 = "<leader>d"; mode = [ "n" "v" ]; }
        { group = "+git";           __unkeyed-1 = "<leader>g"; mode = [ "n" "v" ]; }
        { group = "+find/file";     __unkeyed-1 = "<leader>f"; mode = "n"; }
        { group = "+ui";            __unkeyed-1 = "<leader>u"; mode = "n"; }
        { group = "+windows";       __unkeyed-1 = "<leader>w"; mode = "n"; }
        { group = "+search";        __unkeyed-1 = "<leader><leader>"; mode = "n"; }
      ];
    };
  };
}
