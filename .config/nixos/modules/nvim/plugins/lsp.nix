{ pkgs, ... }:
{
    programs.nixvim = {

        plugins = {
            lsp = {
                enable = true;
                servers = {
                    clangd.enable = true;
                    gleam.enable = true;
                    jdtls.enable = true;
                    lua_ls.enable = true;
                    nil_ls.enable = true;
                    pylsp.enable = true;
                };
            };
        };
        
        keymaps = [
            {mode = "n"; key = "<leader>cl"; action = "<cmd>LspInfo<cr>"; options.desc = "Lsp Info"; }
        ];

        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
