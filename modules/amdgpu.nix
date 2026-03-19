{ pkgs, lib, ... }:

{
	# Enable AMD GPU and Vulkan
	hardware.graphics = {
		enable = lib.mkDefault true;
		enable32Bit = lib.mkDefault true;
	};

	# HIP (High-Intensity Processes)
	systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

	hardware.amdgpu = {
    opencl.enable = lib.mkDefault true;   # Enable OpenCL
    initrd.enable = lib.mkDefault true;   # Load amdgpu in initrd
    # initrd.enable lets your display work earlier in boot
    # (nice for early boot messages/encryption prompts)
  };

	# Enable LACT (Linux AMDGPU Controller)
	services.lact.enable = true;
}
