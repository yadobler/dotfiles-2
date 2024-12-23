{ ... }:
{
    programs.nixvim = {
        keymaps = [
            # up and down in multiline
            { mode = "n"; key = "j"; action = "gj"; }
            { mode = "n"; key = "k"; action = "gk"; }
            
            # Set highlight on search, but clear on pressing <Esc> in normal mode
            { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }

            # Allow search terms to stay in the middle
            { mode = "n"; key = "N"; action = "Nzzzv"; }
            { mode = "n"; key = "n"; action = "nzzzv"; }

            # Windows
            { mode = "n"; key = "<C-Up>"; action = "<C-w>k"; options.desc = "Move To Window Up"; }
            { mode = "n"; key = "<C-Down>"; action = "<C-w>j"; options.desc = "Move To Window Down"; }
            { mode = "n"; key = "<C-Left>"; action = "<C-w>h"; options.desc = "Move To Window Left"; }
            { mode = "n"; key = "<C-Right>"; action = "<C-w>l"; options.desc = "Move To Window Right"; }
            { mode = "n"; key = "<leader>wd"; action = "<C-W>c"; options = { silent = true; desc = "Delete window"; }; }
            { mode = "n"; key = "<leader>-"; action = "<C-W>s"; options = { silent = true; desc = "Split window below"; }; }
            { mode = "n"; key = "<leader>|"; action = "<C-W>v"; options = { silent = true; desc = "Split window right"; }; }

            
        ];
    };
}
