{ ... }:
{
    programs.nixvim = {
        keymaps = [
            # up and down in multiline
            { mode = "n"; key = "j"; action = "gj"; }
            { mode = "n"; key = "k"; action = "gk"; }
            
            # Set highlight on search, but clear on pressing <Esc> in normal mode
            { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; }

        ];
    };
}
