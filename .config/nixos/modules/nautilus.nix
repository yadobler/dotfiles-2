{ pkgs, ... }: {
  programs = {
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "foot";
    };
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
