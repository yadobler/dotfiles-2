{ pkgs, ...}:
  let colorscheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml"; in
{
  environment.systemPackages = with pkgs; [ flavours ];
}
