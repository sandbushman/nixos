_:
let
  unstable = import <nixos-unstable> {
    config.allowUnfree = true;
  };
in
{
  services.llama-cpp = {
    enable = true;
    package = unstable.llama-cpp-vulkan;
    # No model path needed - uses --hf-repo in extraFlags
    extraFlags = [
      "--hf-repo" "bartowski/Qwen_Qwen3.5-9B-GGUF"
      "--hf-file" "Qwen_Qwen3.5-9B-Q4_K_M.gguf"
      "-c" "32768"
      "-ngl" "99"
      "--temp" "1.0"
      "--top-p" "0.95"
      "--top-k" "20"
      "--presence-penalty" "1.5"
      "--reasoning-parser" "qwen3"
    ];
    host = "127.0.0.1";
    port = 8080;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
}