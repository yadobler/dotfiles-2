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

        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
