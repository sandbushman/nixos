{ pkgs, ... }:

{
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
				#ms-vscode.cpptools
				llvm-vs-code-extensions.vscode-clangd
			] ++ [
				nix-vscode-extensions.vscode-marketplace-release.platformio.platformio-vscode-ide
			];
		})
		nixd
		nixfmt
		git
		opencode	# vibecoding in vscode
		ncdu
	];
}
