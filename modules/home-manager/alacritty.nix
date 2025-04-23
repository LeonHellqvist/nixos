{pkgs, ... }:
{
programs.alacritty = {
		enable = true;
		settings = {
			env.TERM = "xterm-256color";
			window.padding = {
				x = 10;
				y=10;
			};
		};
	};
}
