{ pkgs, username, ... }:
{
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [username];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        vhostUserPackages = [ pkgs.virtiofsd ];
        options = [
          "-vga qxl"
          "-spice port=5924,disable-ticketing=on"
          "-device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent"
          "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
        ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true; # enable copy and paste between host and guest
}
