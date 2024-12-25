{ pkgs, ... }:
{
    imports = [
        # ./java.nix
        ./theme.nix
        ./ccc.nix
        ./ts.nix
        ./completion.nix
        ./debugging.nix 
        ./whichkey.nix
        ./lsp.nix
        ./fidget.nix
        ./conform.nix
        ./lspsaga.nix
    ];

    programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
