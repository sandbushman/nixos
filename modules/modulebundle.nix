{ ... }:

{
  imports = [
      ./devtools.nix
      ./arduino.nix
      ./amdgpu.nix
      ./ollama.nix
      ./laptop.nix
      ./virtualization.nix
      ./qol.nix
      #./llama-cpp.nix
  ];
}
