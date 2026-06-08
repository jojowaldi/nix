{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #godot
    unityhub
    _7zip-zstd
  ];

  services.wivrn = {
    enable = false;
    openFirewall = true;
    autoStart = true;
    steam.importOXRRuntimes = true;
    highPriority = true;
  };
}
