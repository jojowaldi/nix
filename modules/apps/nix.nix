{
  pkgs,
  config,
  inputs,
  isLinux,
  lib,
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
    inputs.nix-index-database.${platformModules}.default
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
    nil
    nurl
    nixd
    nixfmt
    mcp-nixos
    nix-init
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
      "https://nix-community.cachix.org"
      "https://projects.cache.profidev.io"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
    ]
    ++ (lib.optionals isLinux [
      (final: prev:
        let
          numen = inputs.custom-nixpkgs.vicinae.inputs.numen.packages.${final.stdenv.hostPlatform.system}.numen.override {
            stdenv = final.gcc15Stdenv;
            withRepl = false;
          };
          vicinae = final.callPackage "${inputs.custom-nixpkgs.vicinae}/nix/vicinae.nix" {
            gcc15Stdenv = final.gcc15Stdenv;
            inherit numen;
          };
          soulver = inputs.custom-nixpkgs.vicinae.inputs.soulver-cpp.packages.${final.stdenv.hostPlatform.system}.default or null;
        in
        {
          inherit vicinae;
          vicinae-with-soulver =
            if soulver != null then
              final.symlinkJoin {
                name = "${vicinae.name}-with-soulver";
                paths = [ vicinae ];
                nativeBuildInputs = [ final.makeWrapper ];
                postBuild = ''
                  for bin in $out/bin/*; do
                    wrapProgram "$bin" \
                      --prefix LD_LIBRARY_PATH : ${soulver}/lib \
                      --prefix XDG_DATA_DIRS : ${soulver}/share
                  done
                '';
                inherit (vicinae) meta;
              }
            else
              vicinae;
        }
      )
    ]);
  };
}
