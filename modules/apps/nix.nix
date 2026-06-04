{
  pkgs,
  config,
  inputs,
  isLinux,
  ...
}:

let
  platform = if isLinux then "nixos" else "darwin";
  platformModules = "${platform}Modules";
  collectFlakeInputs =
    input:
    [ input ] ++ builtins.concatMap collectFlakeInputs (builtins.attrValues (input.inputs or { }));
in
{
  imports = [
    inputs.nix-index-database.${platformModules}.nix-index
  ];

  programs =
    (
      if isLinux then
        {
          nh = {
            enable = true;
            clean.enable = true;
            clean.extraArgs = "--keep-since 1d --keep 10 --optimise";
            clean.dates = "daily";
            flake = config.hostSpec.configPath;
          };
        }
      else
        { }
    )
    // {
      nix-index-database = {
        comma.enable = true;
      };
    };

  environment.systemPackages = with pkgs; [
    nix-index
    nil
    nurl
    nixd
    nixfmt
  ];

  system.extraDependencies =
    (builtins.concatMap collectFlakeInputs (builtins.attrValues inputs))
    ++ (builtins.attrValues inputs.custom-nixpkgs.sources.${pkgs.stdenv.hostPlatform.system});

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = (map (spec: spec.username) config.hostSpec.users);
    tarball-ttl = 2678400; # 31 days
    fallback = true;
    connect-timeout = 5;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
      "https://nix-citizen.cachix.org"
      "https://projects.cache.profidev.io"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    }
    // (
      if isLinux then
        {
          cudaSupport = true;
        }
      else
        { }
    );
    overlays = [
      inputs.rust-overlay.overlays.default
      inputs.custom-nixpkgs.overlays.default
    ];
  };
}
