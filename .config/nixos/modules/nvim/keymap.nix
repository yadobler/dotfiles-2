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

            { mode = "n"; key = "gn"; action = "<cmd>tabnew<CR>"; options.desc = "Opens a new tab";}
        ];
    }; 
}
