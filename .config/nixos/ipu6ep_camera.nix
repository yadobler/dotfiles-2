{ pkgs, ... }:
let 
  ipuVersion = "ipu6ep";
in 
  {
  hardware.ipu6 = {
    enable = true;
    platform = ipuVersion;
  };
  environment.systemPackages = with pkgs; [ ipu6ep-camera-hal ];
}

