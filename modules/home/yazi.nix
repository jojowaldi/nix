{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    ueberzugpp
  ];

  wayland.windowManager.hyprland.extraConfig = builtins.readFile ../../assets/hyprland/yazi.lua;

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    plugins = {
      chmod = "${inputs.yazi-plugins}/chmod.yazi";
      full-border = "${inputs.yazi-plugins}/full-border.yazi";
      mount = "${inputs.yazi-plugins}/mount.yazi";
      # TODO activate
      vcs-files = "${inputs.yazi-plugins}/vcs-files.yazi";
      smart-enter = "${inputs.yazi-plugins}/smart-enter.yazi";
      starship = "${inputs.yazi-starship}";
    };

    theme = (builtins.fromTOML (builtins.readFile ../../assets/other/yazi-theme.toml)) // {
      mgr = {
        syntect_theme = ../../assets/ayu-dark-tmtheme.xml;
      };
    };

    settings = {
      mgr = {
        sort_by = "natural";
        sort_sensitive = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "<Enter>"
          ];
          run = "plugin smart-enter";
          desc = "Enter directories, open files";
        }
        {
          on = [
            "l"
          ];
          run = "plugin smart-enter";
          desc = "Enter directories, open files";
        }
        {
          on = [
            "m"
          ];
          run = "plugin mount";
          desc = "Manage mounts";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
    '';
  };
}
