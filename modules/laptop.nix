{ pkgs, ... }:
let
  unstable = import <nixos-unstable> {
		config.allowUnfree = true;
	};
in
{
  # firmware updates
  services.fwupd.enable = true;

  environment.systemPackages = [
		unstable.auto-cpufreq
    pkgs.powertop
	];


  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };
  # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend",
  # "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
  
  # Disable this, else it conflicts with auto-cpufreq.
  services.power-profiles-daemon.enable = false;
  # auto-cpufreq, a better power management service.
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };
}
