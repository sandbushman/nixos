{ ... }:
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
	];
  /*
  # the module doesn't expose a "services.auto-cpufreq.package" option,
  # therefore the overlay is required.
  nixpkgs.overlays = [
    (self: super: {
      auto-cpufreq = unstable.auto-cpufreq;
    })
  ];
  # UPDATE: unstable is still behind github version..
  # might require more special tricks to get it
  */

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
