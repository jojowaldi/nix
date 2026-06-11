{ pkgs, isLinux, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      jetbrains-toolbox
      zed-editor
      #jetbrains.rider
      #jetbrains.idea
    ]
    ++ (
      if isLinux then
        [
          #antigravity
          android-studio
          code-cursor
          cursor-cli
        ]
      else
        [ ]
    );

  programs.ghidra = {
    enable = true;
    gdb = true;
  };
}
