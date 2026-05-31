{ pkgs, ... }:

# Todo: change to AMD
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      intel-vaapi-driver
      vpl-gpu-rt
    ];
  };
}
