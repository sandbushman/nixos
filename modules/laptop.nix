{ pkgs, ... }:

{
  imports = [
    <nixos-hardware/common/cpu/amd>
    <nixos-hardware/common/cpu/amd/pstate.nix>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/ssd>
    <nixos-hardware/asus/battery.nix>
  ];

  # Battery charge limit (80% extends battery lifespan)
  hardware.asus.battery.chargeUpto = 80;

  # firmware updates
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    powertop
    kdePackages.partitionmanager
  ];
  
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };
  # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend",
  # "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"

  zramSwap.enable = true;
}