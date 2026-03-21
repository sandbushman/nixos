{ pkgs, inputs, ... }:

let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = [
    pkgs-unstable.ollama-vulkan
  ];

  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-vulkan;
    acceleration = "vulkan";
    loadModels = [
      "lfm2.5-thinking:1.2b"
      "rnj-1:8b"
      "qwen3.5:9b"
      "kimi-k2.5:cloud"
      "glm-5:cloud"
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
}