{ ... }:
let
  	unstable = import <nixos-unstable> {
		config.allowUnfree = true;
	};
in
{
	environment.systemPackages = [
		unstable.llama-cpp-vulkan
	];

	services.llama-cpp = {
  	enable = true;	# if false, will not use the declared settings
		package = unstable.llama-cpp-vulkan;	# set service's version to unstable
 		# results in environment variable "HSA_OVERRIDE_GFX_VERSION=11.0.0"
 		#rocmOverrideGfx = "11.0.0";
		model = "~/models/mistral-instruct-7b/ggml-model-q4_0.gguf";
	};
	boot.initrd.kernelModules = [ "amdgpu" ];
}
