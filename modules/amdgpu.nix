{ pkgs, ... }:

{
	# Enable AMD GPU and Vulkan
	hardware.graphics = {
		enable = true;
		enable32Bit = true;
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

	# Enable OpenCL
	hardware.amdgpu.opencl.enable = true;

	# Enable LACT (Linux AMDGPU Controller)
	services.lact.enable = true;
}
