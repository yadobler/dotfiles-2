{ lib, pkgs, ... }:
let
  helpers = lib.nixvim;
in
{
    extraPackages = with pkgs; [
        marksman
        (vimUtils.buildVimPlugin {
            name = "mdx.nvim";
            src = pkgs.fetchFromGitHub {
                owner = "davidmh";
                repo = "mdx.nvim";
                rev = "ae83959";
                hash = "sha256-z835i8QkQFe185sgSLtUaaTsMs2Px9x6KTObTRAOFz0=";
            };
        })
    ];

  plugins = {
    clipboard-image = {
      enable = true;
      clipboardPackage = pkgs.wl-clipboard;
    };

    image = {
      enable = helpers.enableExceptInTests;
      integrations.markdown = {
        clearInInsertMode = true;
        onlyRenderImageAtCursor = true;
      };
    };

    markdown-preview = {
      enable = true;
    };

    lsp.servers = {
      marksman.enable = true;

      ltex = {
        enable = true;
        filetypes = [
          "markdown"
          "text"
        ];

        settings.completionEnabled = true;

        extraOptions = {
          checkFrequency = "save";
          language = "en-GB";
        };
      };
    };

    lint = {
      lintersByFt.md = [ "markdownlint-cli2" ];
      linters.markdownlint-cli2.cmd = "${pkgs.markdownlint-cli2}/bin/markdownlint-cli2";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>m";
      action = "<cmd>MarkdownPreviewToggle<cr>";
      options = {
        silent = true;
        desc = "Toggle markdown preview";
      };
    }
  ];
}
