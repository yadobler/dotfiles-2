{ pkgs, system, inputs, colorScheme, ... }:
{
  imports = [
    ./modules/themes
    ./modules/gnome_polkit.nix
    ./modules/terminal.nix
    ./modules/vscode.nix
    ./modules/nautilus.nix
    ./modules/qemu.nix
    ./modules/spotify.nix
    ./modules/niri.nix

    #./modules/hyprland.nix
    #./modules/nvim 
    #./modules/binja
    #./modules/obs.nix
    #./modules/nemo.nix
    #./modules/thunar.nix

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
        theme = "base16";
      };
      # extraPackages = with pkgs.bat-extras; [
      #
      # ];
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    (inputs.nixvim.packages.${system}.withColor {
      colorScheme = {palette = lib.mapAttrs (_: v: "#" + v) colorScheme.palette; };
    })
    # inputs.nixvim.packages.${system}.default
    inputs.binja.packages.${system}.default
    inputs.wkeys.packages.${system}.default

    gh
    stow

    imagemagick
    ffmpeg
    libnotify
    libsixel
    pandoc
    texliveFull
    glow

    stable.brave
    telegram-desktop
    zathura
    xournalpp
    swayimg
    clapper
    neovide
    arduino
    scenebuilder
    obsidian

    adwaita-icon-theme
    adwaita-qt
    # morewaita-icon-theme
    gnome-tweaks

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
