{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    flavours
  ];

  
}
