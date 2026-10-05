{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #asublender
    #blockbench
    webots
  ];
}
