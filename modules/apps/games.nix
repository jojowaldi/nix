{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    heroic
    ferium
    #lutris
    r2modman
    playonlinux
    wine
    wine64
    winetricks
    gamemode

    #inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.rsi-launcher
    inputs.proton.packages.${stdenv.hostPlatform.system}.default
  ];
}
