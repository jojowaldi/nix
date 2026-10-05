{ pkgs, isLinux, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      jetbrains-toolbox
      zed-editor

    ]
    ++ (
      if isLinux then
        [

          #android-studio
          code-cursor
          cursor-cli
          #antigravity
          antigravity-cli       
        ]
      else
        [ ]
    );

  programs.ghidra = {
    enable = true;
    gdb = true;
  };
}
