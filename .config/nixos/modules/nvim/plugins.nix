{ pkgs, ... }:
{
    imports = [
        # ./plugins/java.nix
        ./plugins/theme.nix
        ./plugins/ccc.nix
        ./plugins/ts.nix
    ];

    programs.nixvim = {
        extraPlugins = with pkgs.vimPlugins; [
        ];

        extraConfigLua = ''
        '';
    };
}
