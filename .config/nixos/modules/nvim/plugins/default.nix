{ pkgs, ... }:
{
    imports = [
        # ./java.nix
        ./theme.nix
        ./ccc.nix
        ./ts.nix
    ];

    programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
