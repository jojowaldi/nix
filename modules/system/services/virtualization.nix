{ pkgs, pkgsUnstableNoCuda, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    distrobox
    libvirt
    virt-manager
    qemu
    uefi-run
    lxc
    swtpm
    #bottles
  ];

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

  virtualisation.libvirtd = {
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };
  environment.variables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
      package = pkgsUnstableNoCuda.virtualbox;
    };
  };

  virtualisation.waydroid.enable = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];
}
