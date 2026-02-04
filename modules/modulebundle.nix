{ ... }:

{
  imports = [
      ./devtools.nix
      ./arduino.nix
      ./amdgpu.nix
      ./ollama.nix
      ./laptop.nix
      ./virtualization.nix
      #./llama-cpp.nix
  ];
}
