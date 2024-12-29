{ lib, ... }:
let
  helpers = lib.nixvim;
in
{
        autoCmd = [
            {
                event = [
                    "BufEnter"
                    "BufNew"
                ];
                desc = "disable statuscolumn for neo-tree and dashboard";
                callback = helpers.mkRaw ''
        function()
            local ft_ignore = { "dashboard", "neo-tree" }
            if vim.tbl_contains(ft_ignore, vim.bo.filetype) then
                vim.cmd("setlocal foldcolumn=0")
            end
        end
        '';
            }
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
}
