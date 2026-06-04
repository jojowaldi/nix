{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-config.nix

    ../../spec.nix

    # Profiles
    ../../../modules/profiles/system/base.nix
    ../../../modules/profiles/system/laptop.nix

    ../../../modules/profiles/apps/base.nix
    ../../../modules/profiles/apps/gamedev.nix
    ../../../modules/profiles/apps/graphics.nix
    ../../../modules/profiles/apps/office.nix

    # Extra
    ../../../modules/system/services/docker.nix
    ../../../modules/apps/tailscale.nix
    ../../../modules/apps/cloudflare.nix
    ../../../modules/apps/steam.nix
  ];

  hostSpec = {
    hostname = "laptop";
    users = [
      inputs.nix-secrets.users.jojowaldi
      {
        username = "root";
        secrets_user = "root";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    asusctl
  ];

  services.asusd.enable = true;
}
