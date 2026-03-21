{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.asus-battery
  ];

  hardware.asus.battery.chargeUpto = 80;

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

  zramSwap.enable = true;
}