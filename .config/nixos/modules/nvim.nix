{ pkgs, inputs, ... }:
{
	imports = [inputs.nixvim.nixosModules.nixvim];
	programs.nixvim = {
		enable = true;
		#colorschemes.habemax.enable = true;
		colorschemes.oxocarbon.enable = true;
		plugins = {
			lualine.enable = true;
			gitsigns.enable = true;
			comment.enable = true;
			hop.enable = true;
			which-key = {
			    enable = true;
			    settings.spec = [
                    {__unkeyed-1 = "<leader>c"; "desc" =  "[C]ode";}
                    {__unkeyed-1 = "<leader>d"; "desc" =  "[D]ocument";}
                    {__unkeyed-1 = "<leader>r"; "desc" =  "[R]ename";}
                    {__unkeyed-1 = "<leader>s"; "desc" =  "[S]earch";}
                    {__unkeyed-1 = "<leader>w"; "desc" =  "[W]orkspace";}
                    {__unkeyed-1 = "<leader>t"; "desc" =  "[T]oggle";}
                    {__unkeyed-1 = "<leader>h"; "desc" =  "Git [H]unk";}
			    ];
            };
            telescope.enable = true;
            rust-tools.enable = true;
            #nvim-jdtls.enable = true;
            markdown-preview.enable = true;
            indent-blankline.enable = true;
		};
		extraPlugins = with pkgs.vimPlugins; [
            oxocarbon-nvim
            nvim-web-devicons
            ccc-nvim 
            crates-nvim
            neodev-nvim
			#mini-icons-nvim
            #tree-sitter-hyprlang
		]; 
		# ++[
        #      (pkgs.vimUtils.buildVimPlugin {
        #       pname = "tree-sitter-hyprlang";
        #       version = "0.0.1";
        #       src = pkgs.fetchFromGitHub {
        #       owner = "luckasRanarison";
        #       repo = "tree-sitter-hyprlang";
        #       rev = "";
        #       hash = "sha256-w6yn8aNcJMLRbzaRuj3gj4x2J/20wUROLM6j39wpZek=";
        #       };
        #       })
		# ];
		extraConfigLua = ''
		    
            require('ccc').setup({
                highlighter = {
                    auto_enable = true,
                    lsp = true,
                },
                DEFAULT_OPTIONS = {
                    RGB      = true;         -- #RGB hex codes
                    RRGGBB   = true;         -- #RRGGBB hex codes
                    names    = true;         -- "Name" codes like Blue
                    RRGGBBAA = true;        -- #RRGGBBAA hex codes
                    rgb_fn   = true;        -- CSS rgb() and rgba() functions
                    hsl_fn   = true;        -- CSS hsl() and hsla() functions
                    css      = true;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn   = true;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
                    -- Available modes: foreground, background
                    mode     = 'background'; -- Set the display mode.
                }
            })


		'';

		keymaps = [
			{
				mode = "n";
				key = "<Esc>";
				action = "<cmd>nohlsearch<CR>";
			}
		];

		globals.autochdir = false;
		globals.loaded_netrw = 1;
		globals.loaded_newrwPlugin = 1;

		# Display
		globals.have_nerd_font = true;
		opts.termguicolors = true;
		opts.guifont = "FiraCode NFP:h13";
		opts.encoding = "utf-8";
		opts.showmode = false;
		opts.laststatus = 2;
		opts.background = "dark";
		opts.backspace = "indent,eol,start";

		# locale
		#opts.spelllang:append "cjk"; # disable spellchecking for asian characters (VIM algorithm does not support it)
		#opts.shortmess:append "c"; # don't show redundant messages from ins-completion-menu
		#opts.shortmess:append "I"; # don't show the default intro message
		#opts.whichwrap:append "<,>,[,],h,l";

		# Timeouts
		opts.timeoutlen = 500;
		opts.ttimeout = true;
		opts.ttimeoutlen = 5;
		opts.updatetime = 250;

		# Visual Updating
		opts.signcolumn = "yes";
		opts.scrolloff = 5;
		opts.showmatch = true;
		opts.errorbells = false;

		# Mouse
		opts.mouse = "nv";
		opts.mousefocus = true;

		# Numbering
		opts.number = true;
		opts.relativenumber = true;
		opts.ruler = false;

		# Autoformatting
		opts.autoindent = true;
		opts.expandtab = true;
		opts.shiftwidth = 4;
		opts.tabstop = 4;
		opts.softtabstop = 4;
		opts.smartindent = true;
		opts.wrap = false;
		opts.foldenable = true;
		opts.foldlevel = 99;
		opts.foldlevelstart = 99;
		opts.foldmethod = "manual";
		opts.copyindent = true;

		# Search
		opts.ignorecase = true;
		opts.smartcase = true;
		opts.hlsearch = true;

		# Metadata
		opts.history = 100;
		opts.undofile = true;

		# Preview substitutions live, as you type!
		opts.inccommand = "split";

		# Fillchars
		opts.fillchars = {
			vert = "│";
			fold = "⠀";
			eob = " ";
			# suppress ~ at EndOfBuffer
			diff = "░"; # alternatives = ⣿ ░ ─ ╱
			msgsep = "‾";
			foldopen = "▾";
			foldsep = "│";
			foldclose = "▸";
		};

		# leader keys
		globals.mapleader = " ";
		globals.localmapleader = " ";

		autoCmd = [
		{
			# restore cursor
			command = "silent! normal! g`\"zv";
			desc = "return cursor to where it was last time closing the file";
			pattern = ["*"];
			event = ["BufWinEnter"];
		}
		{
			command = "normal! <Cmd>noh<cr>";
			event = ["InsertEnter"];
			pattern = ["*"];
		}
		];
	};
}
