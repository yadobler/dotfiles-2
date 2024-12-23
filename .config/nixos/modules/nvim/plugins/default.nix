{ pkgs, ... }:
{
    imports = [
        # ./java.nix
        ./theme.nix
        ./ccc.nix
        ./ts.nix
        ./completion.nix
        ./debugging.nix 
        ./whickkey.nix
    ];

    programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
