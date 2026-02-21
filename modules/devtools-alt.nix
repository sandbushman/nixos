{ pkgs, lib, ... }:
let
  nix-vscode-extensions = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nix-vscode-extensions.git";
    ref = "refs/heads/master";
  });
	resetLicense = drv: drv.overrideAttrs (prev: {
		meta = prev.meta // { license = [ ]; };
	});
in
{
	# Add nix-vscode-extensions overlay
  	nixpkgs.overlays = [
    	nix-vscode-extensions.overlays.default
 	];

	environment.systemPackages = with pkgs; [
		tldr
		#fish
		(vscode-with-extensions.override {
			vscode = vscodium;
			vscodeExtensions = 
				(with vscode-extensions; [
				christian-kohler.path-intellisense
				jnoortheen.nix-ide
				arrterian.nix-env-selector
				ms-python.python
				ms-python.debugpy
				#platformio.platformio-vscode-ide
				#pioarduino.pioarduino-ide
				#ms-vscode.cpptools
				llvm-vs-code-extensions.vscode-clangd
			])
			++ (lib.lists.optionals (
				lib.lists.elem
				stdenv.hostPlatform.system
				lib.platforms.linux
			) (with pkgs.nix-vscode-extensions.vscode-marketplace; [
        # Exclusively for testing purposes
        (resetLicense ms-vscode.cpptools)
        (platformio.platformio-ide)
      ]));
		}) 
		nixd
		nixfmt
		git
		github-desktop
		opencode	# vibecoding in vscode
		platformio-core # arduino
		ncdu
	];
}
