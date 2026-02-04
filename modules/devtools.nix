{ pkgs, ... }:
let
  nix-vscode-extensions = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nix-vscode-extensions.git";
    ref = "refs/heads/master";
  });
in
{
	# Add nix-vscode-extensions overlay
  	nixpkgs.overlays = [
    	(nix-vscode-extensions.overlays.default)
 	];

	environment.systemPackages = with pkgs; [
		tldr
		#fish
		(vscode-with-extensions.override {
			vscode = vscodium;
			vscodeExtensions = with vscode-extensions; [
				christian-kohler.path-intellisense
				jnoortheen.nix-ide
				arrterian.nix-env-selector
				ms-python.python
				ms-python.debugpy
				#platformio.platformio-vscode-ide
				#pioarduino.pioarduino-ide
				#ms-vscode.cpptools
				llvm-vs-code-extensions.vscode-clangd
			];
		})
		nixd
		nixfmt
		git
		github-desktop
		opencode	# vibecoding in vscode
		platformio-core
		ncdu
	];
}
