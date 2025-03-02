{ pkgs, ... }: {
  programs = {
    nautilus-open-any-terminal.enable = true;
    dconf.enable = true;

  };

  services = {
    gvfs.enable = true;
    gnome.sushi.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nautilus
  ];
}
