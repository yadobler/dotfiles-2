{ pkgs, username, ... }:
{
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [username];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = [ pkgs.virtiofsd ];
    };
    spiceUSBRedirection.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest
}
