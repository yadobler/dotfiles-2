{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        brave
    ];
    xdg.portal = {
        enable = true;
        wlr.enable = true;
    };
}
