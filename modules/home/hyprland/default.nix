{ hostSpec, ... }:

{
  imports = [
    ./noctalia.nix
    ./io.nix
    ./keybinds.nix
    ./layers.nix
    ./style.nix
    ./vicinae.nix
    ./wallpaper.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    systemd.enable = false;
    package = null;
    portalPackage = null;
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprland-session.target"
      ];

      # Miscellaneous
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Environment
      env = [
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OYONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "QT_QPA_PLATFORMTHEME_QT6,gtk3"
      ];

      xwayland = {
        force_zero_scaling = hostSpec.hyprlandHiDpiFix;
      };
    };
  };

  services.hyprpolkitagent.enable = true;
}
