{ pkgs, username,...}:
let 
  colorscheme_name = "oxocarbon-dark";
  colorscheme = "${pkgs.base16-schemes}/share/themes/${colorscheme_name}.yaml"; 
  flavours_pkg="${pkgs.flavours}/bin/flavours";
in {
  environment.systemPackages = with pkgs; [ tinty ];
  # system.activationScripts.check_colorscheme = ''
  #   [ "$(</home/${username}/.local/share/flavours/lastscheme)" == "${colorscheme_name}" ] && exit
  #   mkdir -p /home/${username}/.local/share/flavours/base16/schemes/${colorscheme_name}
  #   cp -u ${colorscheme} /home/${username}/.local/share/flavours/base16/schemes/${colorscheme_name}
  # '';
}
