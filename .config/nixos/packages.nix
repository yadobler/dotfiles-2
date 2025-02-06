{ pkgs, ... }:
{
  imports = [
    #./modules/hyprland.nix
    #./modules/gnome_polkit.nix
    #./modules/nvim
    #./modules/obs.nix
    #./modules/nemo.nix
    #./modules/thunar.nix

    ./modules/nautilus.nix
    ./modules/gnome.nix
    ./modules/terminal.nix
    ./modules/vscode.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # programmes
  programs = {
    git.enable = true;
    light.enable = true;
    bat = {
      enable = true;
      settings = {
        theme = "cyberdream";
      };
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wallust
    gh
    stow
    
    imagemagick
    ffmpeg
    libnotify
    libsixel
    pandoc
    texliveFull
    glow

    brave
    telegram-desktop
    xournalpp
    swayimg
    spotify
    neovide
    arduino
    scenebuilder
    obsidian
    vlc
    # zathura
    # clapper
    
    # adwaita-icon-theme
    # adwaita-qt
    # morewaita-icon-theme
    # gnome-tweaks
    # jetbrains.idea-community

  ];

  # Font
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      jetbrains-mono
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Nerd Font Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
