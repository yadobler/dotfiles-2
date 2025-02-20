{ pkgs, ...}:
let 
  colorscheme = "oxocarbon-dark";
in
{
  environment.systemPackages = with pkgs; [
    flavours
  ];

}
