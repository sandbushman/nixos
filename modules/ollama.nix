{ ... }:
let
  	unstable = import <nixos-unstable> {
		config.allowUnfree = true;
	};
in
{
	environment.systemPackages = [
		unstable.ollama-vulkan
	];

	services.ollama = {
  	enable = true;	# if false, will not use the declared settings
		package = unstable.ollama-vulkan;	# set service's version to unstable
 		acceleration = "vulkan";
 		# results in environment variable "HSA_OVERRIDE_GFX_VERSION=11.0.0"
 		#rocmOverrideGfx = "11.0.0";
		loadModels = [
			"lfm2.5-thinking:1.2b"
			"rnj-1:8b"
			"kimi-k2.5:cloud"
			"glm-4.7:cloud"
		];
	};

	boot.initrd.kernelModules = [ "amdgpu" ];
}
