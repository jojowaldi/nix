{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-radeon
      libva-mesa-driver
    ];
  };
}
