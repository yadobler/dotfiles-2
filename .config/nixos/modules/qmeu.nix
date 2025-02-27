{pkgs, ... }:
{
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        # ovmf.enable = true;
        # ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    # spiceUSBRedirection.enable = true;
  };
  # services.spice-vdagentd.enable = true;
}
