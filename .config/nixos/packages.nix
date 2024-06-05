{ pkgs, ... }: {
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	
	# programmes
	programs = {
		git.enable = true;
		hyprland.enable = true;
		hyprlock.enable = true;
		light.enable = true;
		neovim.enable = true;
		waybar.enable = true;
		xwayland.enable = true;
		zsh.enable = true;
	};
	services = {
		hypridle.enable = true;
	};

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
	};

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		bat
		brave
		ffmpeg
		file
		foot
		gcc
		gh
		grim
		libnotify
		lsd
		lxqt.lxqt-policykit
		mako
		neofetch
		pamixer
		pipewire
		pstree
		pulseaudio
		slurp
		stow
		swappy
		telegram-desktop
		tree
		unzip
		wbg
		wget
		wl-clipboard
		wofi
		swayimg
	];
	
	# Font
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		fira-code
		fira-math
		fira-code-symbols
		(nerdfonts.override { fonts = [ "FiraCode" ]; })
	];
}
