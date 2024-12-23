{ ... }:
{
    programs.nixvim = {
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
