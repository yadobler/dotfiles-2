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
    waybar.enable = true;
    xwayland.enable = true;
    nm-applet.enable = true;
    file-roller.enable = true;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    bat
    file
    lsd
    fd
    ripgrep
    oh-my-posh
    bottom
    neovide

    neofetch
    pstree
    tree
    unzip
    wget
    jq
    bc

    glm
    meson
    ninja
    gcc
    gh
    stow
    glib
    tree-sitter
    nodejs
    go
    zig
    cargo
    rustc
    nil # nix lsp
    poetry

    # gleam
    # erlang
    # rebar3

    brave
    telegram-desktop
    zathura
    xournalpp
    swayimg
    clapper
    spotify

    imagemagick
    ffmpeg
    libnotify
    pamixer
    pipewire
    pulseaudio
    pavucontrol

    dunst
    grim
    slurp
    wf-recorder
    swappy
    wl-clipboard
    cliphist
    wofi
    iio-sensor-proxy
    squeekboard
    playerctl
    glow

    wallust
    adwaita-icon-theme
    adwaita-qt
    morewaita-icon-theme
    gnome-tweaks
    banana-cursor

    # jetbrains.idea-community
    arduino
    scenebuilder
    obsidian
    gdb
    p7zip
    binwalk
    pandoc
    texliveFull
    binwalk


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

      # Legacy for <= 24.05
      #(nerdfonts.override { 
      #    fonts = [ 
      #        "JetBrainsMono" 
      #    ]; 
      #})
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
