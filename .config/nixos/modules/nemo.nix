{ pkgs, ... }: {
    services = {
        gvfs.enable = true;
        tumbler.enable = true;
    };

    environment.systemPackages = with pkgs; [
        ffmpegthumbnailer
        poppler
        #cinnamon.nemo-with-extensions
        cinnamon.nemo
        cinnamon.nemo-emblems
        cinnamon.nemo-fileroller
    ];
}
