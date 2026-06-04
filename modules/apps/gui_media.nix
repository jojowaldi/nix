{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    discord
    spotify
    karere
    chromium
    rpi-imager
    teamspeak6-client
    blockbench
    zathura
  ];
}
