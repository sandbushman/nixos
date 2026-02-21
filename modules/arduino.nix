{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		python310
		python313
		python313Packages.venvShellHook
		#python315
		arduino-ide
		arduino-language-server	# requires cli and clangd
		arduino-cli # this is cli
		llvmPackages_21.clang-tools	# this is clangd
		cmake
	];

	/* solution 2: udev rules
	services.udev.extraRules = ''
  SUBSYSTEM=="tty", ATTRS{idVendor}=="*", ATTRS{idProduct}=="*", MODE="0666", GROUP="dialout"
'';
	*/
	/* solution 3: extraGroups
	users.users.quartzbrush.extraGroups = [ "dialout" "tty" ];
	*/
}
