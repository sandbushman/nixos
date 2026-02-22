{ pkgs, ... }:

{
  # Installing the hypervisor on host system.
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Default libvirt network for DNS/DHCP functionality.
  environment.systemPackages = with pkgs; [ 
  dnsmasq 
  ];
  # Run "virsh net-start default" to enable network.
  # Run "virsh net-autostart default" to enable automatically at boot.
  # Allow virtual network bridge "virbr0".
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Allow virt-manager to run in Wayland. 
  /*
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
  */
}