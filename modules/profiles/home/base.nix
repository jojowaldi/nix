{ ... }:

{
  imports = [
    ../../home/direnv.nix
    ../../home/fastfetch.nix
    ../../home/git.nix
    ../../home/gpg.nix
    ../../home/media.nix
    ../../home/nvim.nix
    ../../home/shell.nix
    ../../home/fish.nix
    ../../home/sops.nix
    ../../home/ssh.nix
    ../../home/starship.nix
    ../../home/yazi.nix
    ../../home/zoxide.nix
  ];

  programs.home-manager.enable = true;
}
