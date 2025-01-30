{ pkgs, ... }:
{
  imports = [
    ./modules/hyprland.nix
    ./modules/gnome_polkit.nix
    ./modules/terminal.nix
    ./modules/thunar.nix
    ./modules/vscode.nix

    #./modules/nvim
    #./modules/obs.nix
    #./modules/nemo.nix

  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # programmes
  programs = {
    git.enable = true;
    light.enable = true;
    file-roller.enable = true;
    bat = {
      enable = true;
      settings = {
        theme = "cyberdream";
      };
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    file
    lsd
    fd
    dust
    duf
    fzf
    ripgrep
    bottom
    neofetch
    pstree
    tree
    unzip
    p7zip
    wget
    jq
    bc
    binwalk

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
    zathura
    xournalpp
    swayimg
    clapper
    spotify
    neovide
    arduino
    scenebuilder
    obsidian

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
