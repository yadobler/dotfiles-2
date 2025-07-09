{ inputs, system, pkgs, ... }: 
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in
  {
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify 
  ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      popupLyrics
      betterGenres
      oneko
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    # theme = {
    #   name = "Base16";
    #   src = ~/.config/spicetify;
    #   injectCss = false;
    # };
  };
}
