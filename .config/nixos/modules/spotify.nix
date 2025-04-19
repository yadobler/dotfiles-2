{ inputs, system, ... }: 
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in
  {
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      keyboardShortcut
      popupLyrics
      betterGenres
      beautifulLyrics
      oneko
      shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    theme = spicePkgs.themes.hazy;
  };
}
