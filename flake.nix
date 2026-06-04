{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
      "https://nix-citizen.cachix.org"
      "https://projects.cache.profidev.io"
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
      "http://192.168.178.22:5000"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "profidev.cachix.org:tg4xEn64UMdvA5jJYT8omo/CQHk8+spLyeGT2YAku70="
    ];
    connect-timeout = 5;
    fallback = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    custom-nixpkgs.url = "github:ProfiiDev/custom-nixpkgs";

    proton.url = "github:profiidev/proton/latest";
    hibernation.url = "github:profiidev/hibernation/latest";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-secrets.url = "git+ssh://git@github.com/ProfiiDev/nix-secrets.git?ref=main&shallow=1";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    keyring-unlocker-src = {
      url = "github:recolic/gnome-keyring-yubikey-unlock";
      flake = false;
    };

    nix-citizen = {
      url = "github:LovingMelody/nix-citizen?rev=cb5c54868dfca5377f0fea5c983aef833acdd4b5";
      inputs = {
        nix-gaming.follows = "nix-gaming";
      };
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    yazi-starship = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      ...
    }:
    let
      specialArgs = pkgs: {
        inherit inputs self;
        lib = pkgs.lib.extend (
          self: super: {
            custom = import ./lib { inherit (pkgs) lib; };
          }
        );
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs-unstable.lib.nixosSystem {
            specialArgs = specialArgs nixpkgs-unstable // {
              inherit host;
              isLinux = true;
            };
            modules = [ ./hosts/profiles/${host} ];
          };
        }) (nixpkgs-unstable.lib.attrNames (builtins.readDir ./hosts/profiles))
      );

      # https://nix-darwin.github.io/nix-darwin/manual/index.html
      darwinConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nix-darwin.lib.darwinSystem {
            specialArgs = specialArgs nixpkgs-unstable // {
              inherit host;
              isLinux = false;
            };
            modules = [ ./hosts/mac/${host} ];
          };
        }) (nixpkgs.lib.attrNames (builtins.readDir ./hosts/mac))
      );
    };
}
