{ inputs, system, ... }:
{
    imports = [
        inputs.nixvim.nixosModules.nixvim
        ./plugins
        ./autocmd.nix
        ./keymap.nix
    ];

    environment.systemPackages = [
        # inputs.goneovim.defaultPackage.${system} # "x86_64-linux"
    ];

    programs.nixvim = {
        enable = true;
        extraConfigLua = ''
            -- locale
            vim.o.spelllang = vim.o.spelllang .. ",cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
            vim.o.shortmess = vim.o.shortmess .. "c" -- don't show redundant messages from ins-completion-menu
            vim.o.shortmess = vim.o.shortmess .. "I" -- don't show the default intro message
            vim.o.whichwrap = vim.o.whichwrap .. ",<,>,[,],h,l"
        '';

        highlight = {
            "RainbowRed" = { fg = "#FF0071" ;};
            "RainbowYellow" = { fg = "#FFFB00" ;};
            "RainbowBlue" = { fg = "#61AFEF" ;};
            "RainbowOrange" = { fg = "#FFB151" ;};
            "RainbowGreen" = { fg = "#4CDB68" ;};
            "RainbowViolet" = { fg = "#FF80FF" ;};
            "RainbowCyan" = { fg = "#56B6C2" ;};
        };

        globals = {
            rainbow_delimiters.__raw = ''
            {
                highlight = {
                    "RainbowRed",
                    "RainbowYellow",
                    "RainbowBlue",
                    "RainbowOrange",
                    "RainbowGreen",
                    "RainbowViolet",
                    "RainbowCyan",
                }
            }
            '';

            autochdir = false;
            loaded_netrw = 1;
            loaded_newrwPlugin = 1;
            have_nerd_font = true;

            # leader keys
            mapleader = " ";
            localmapleader = " ";
        };

        opts = {
            # Display
            termguicolors = true;
            guifont = "FiraCode NFP:h13";
            encoding = "utf-8";
            showmode = false;
            laststatus = 2;
            background = "dark";
            backspace = "indent,eol,start";

            # Timeouts
            timeoutlen = 500;
            ttimeout = true;
            ttimeoutlen = 5;
            updatetime = 250;

            # Visual Updating
            signcolumn = "yes";
            scrolloff = 5;
            showmatch = true;
            errorbells = false;

            # Mouse
            mouse = "nv";
            mousefocus = true;

            # Numbering
            number = true;
            relativenumber = true;
            ruler = false;

            # Autoformatting
            autoindent = true;
            expandtab = true;
            shiftwidth = 4;
            tabstop = 4;
            softtabstop = 4;
            smartindent = true;
            wrap = false;
            foldenable = true;
            foldlevel = 99;
            foldlevelstart = 99;
            foldmethod = "manual";
            copyindent = true;

            # Search
            ignorecase = true;
            smartcase = true;
            hlsearch = true;

            # Metadata
            history = 100;
            undofile = true;

            # Preview substitutions live, as you type!
            inccommand = "split";

            # Fillchars
            fillchars = {
                vert = "│";
                fold = "⠀";
                eob = " "; # suppress ~ at EndOfBuffer
                diff = "░";
                msgsep = "‾";
                foldopen = "▾";
                foldsep = "│";
                foldclose = "▸";
            };
        };
    };
}
