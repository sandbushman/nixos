{ pkgs, ... }:

{
  # Installing the hypervisor on host system.
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      
    };
  };
  programs.virt-manager.enable = true;

  # Default libvirt network for DNS/DHCP functionality.
  virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [ virtiofsd ];

  environment.systemPackages = with pkgs; [
    qemu
    dnsmasq
    # diagnosis tools
    nvme-cli
  ];

  # Define and autostart the default network
  systemd.services.libvirtd-default-network = {
    description = "Libvirt default network";
    wantedBy = [ "multi-user.target" ];
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      # Wait for libvirtd to be ready
      sleep 2

      # Check if default network already exists
      if ! ${pkgs.libvirt}/bin/virsh net-list --all | grep -q "default"; then
        # Create default network if it doesn't exist
        ${pkgs.libvirt}/bin/virsh net-define /dev/stdin <<'EOF'
      <network>
        <name>default</name>
        <forward mode='nat'/>
        <bridge name='virbr0' stp='on' delay='0'/>
        <ip address='192.168.122.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.122.2' end='192.168.122.254'/>
          </dhcp>
        </ip>
      </network>
      EOF
        ${pkgs.libvirt}/bin/virsh net-autostart default
      fi

      # Start the network if not already active
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';
  };
  /*
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - 
    ${pkgs.qemu}/share/qemu/firmware"
  ];*/
  /*
  environment.etc = {
    "ovmf/edk2-x86_64-code.fd".source = "${pkgs.qemu}/share/qemu/edk2-x86_64-code.fd";
    "ovmf/edk2-i386-vars.fd".source = "${pkgs.qemu}/share/qemu/edk2-i386-vars.fd";
  };
  */
  # Run "virsh net-start default" to enable network.
  # Run "virsh net-autostart default" to enable automatically at boot.
  # Allow virtual network bridge "virbr0".
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
