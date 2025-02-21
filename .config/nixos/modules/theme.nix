{ pkgs, username,...}:
let 
  colorscheme_name = "oxocarbon-dark";
  colorscheme = "${pkgs.base16-schemes}/share/themes/${colorscheme_name}.yaml"; 
in {
  environment.systemPackages = with pkgs; [ flavours ];
  system.userActivationScripts.check_colorscheme = ''
    [ "$(flavours current)" == "${colorscheme_name}" ] && exit
    mkdir -p /home/${username}/.config/flavours/schemes/${colorscheme_name}
    cp -u ${colorscheme} /home/${username}/.config/flavours/schemes/${colorscheme_name}/${colorscheme_name}.yaml
    flavours -c /home/${username}/.config/flavours/config.toml -d /home/${username}/.config/flavours/ apply ${colorscheme_name}
  '';
}
