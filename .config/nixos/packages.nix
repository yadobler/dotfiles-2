{ pkgs, ... }: {
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	
	# programmes
	programs = {
		zsh.enable = true;
		hyprland.enable = true;
		hyprlock.enable = true;
	};
	services = {
		hypridle.enable = true;
	};

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
	};

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		libnotify
		lsd
		bat
		git
		file
		tree
		wget
		unzip	
		telegram-desktop
		wofi
		neofetch
		light
		ffmpeg
		xwayland
		pipewire
		pulseaudio
		pamixer
		swappy
		neovim 
		brave
		waybar
		mako
		wl-clipboard
		grim
		slurp
		wbg
		lxqt.lxqt-policykit
		stow
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
